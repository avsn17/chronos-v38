#!/usr/bin/env python3
import os, sys, json, signal, threading, subprocess
from http.server import HTTPServer, BaseHTTPRequestHandler
from pathlib import Path

PORT        = int(sys.argv[sys.argv.index('--port')+1]) if '--port' in sys.argv else 8765
SIGNAL_FILE = Path('music_signal.txt')
DATA_DIR    = Path('data')
PLAYERS     = ['mpv', 'vlc', 'ffplay']
current_process = None
track_index = 0
lock = threading.Lock()

def find_player():
    for p in PLAYERS:
        if subprocess.run(['which', p], capture_output=True).returncode == 0:
            return p
    return None

def scan_tracks():
    files = []
    for ext in ('*.mp3','*.ogg','*.flac','*.wav','*.m4a'):
        files.extend(sorted(DATA_DIR.glob(ext)))
    return [str(f) for f in files]

def play_track(index=0):
    global current_process, track_index
    player = find_player()
    tracks = scan_tracks()
    if not tracks:
        print('[MUSIC] No tracks in data/ - YouTube stream opens in browser.')
        write_signal('IDLE'); return
    track_index = index % len(tracks)
    stop_player()
    track = tracks[track_index]
    print(f'[MUSIC] PLAY -> {track}')
    cmds = {
        'mpv':    ['mpv', '--no-video', '--really-quiet', track],
        'vlc':    ['vlc', '--intf', 'dummy', '--play-and-exit', track],
        'ffplay': ['ffplay', '-nodisp', '-autoexit', track],
    }
    cmd = cmds.get(player)
    if not cmd:
        print('[MUSIC] No player found. Install mpv, vlc, or ffplay.'); return
    current_process = subprocess.Popen(cmd)
    write_signal('IDLE')

def stop_player():
    global current_process
    if current_process and current_process.poll() is None:
        current_process.terminate()
        try: current_process.wait(timeout=2)
        except subprocess.TimeoutExpired: current_process.kill()
    current_process = None

def pause_player():
    if current_process and current_process.poll() is None:
        current_process.send_signal(signal.SIGSTOP)
        print('[MUSIC] PAUSE')

def resume_player():
    if current_process and current_process.poll() is None:
        current_process.send_signal(signal.SIGCONT)
        print('[MUSIC] RESUME')

def write_signal(action): SIGNAL_FILE.write_text(action)

def handle_signal(action):
    action = action.upper().strip()
    write_signal(action)
    print(f'[SIGNAL] {action}')
    with lock:
        if   action == 'PLAY_NEXT': play_track(track_index + (1 if current_process else 0))
        elif action == 'STOP':      stop_player()
        elif action == 'PAUSE':     pause_player()
        elif action == 'RESUME':    resume_player()

class SignalHandler(BaseHTTPRequestHandler):
    def log_message(self, fmt, *args): pass
    def do_POST(self):
        if self.path == '/signal':
            try:
                data = json.loads(self.rfile.read(int(self.headers.get('Content-Length',0))))
                handle_signal(data.get('action','IDLE'))
                self._ok({'ok': True})
            except Exception as e: self._ok({'error': str(e)}, 400)
        else: self._ok({'error': 'not found'}, 404)
    def do_GET(self):
        if self.path == '/status':
            tracks = scan_tracks()
            self._ok({'signal': SIGNAL_FILE.read_text() if SIGNAL_FILE.exists() else 'IDLE',
                      'playing': current_process is not None and current_process.poll() is None,
                      'tracks': len(tracks), 'player': find_player()})
        else: self._ok({'error': 'not found'}, 404)
    def do_OPTIONS(self):
        self.send_response(200); self._cors(); self.end_headers()
    def _ok(self, data, code=200):
        body = json.dumps(data).encode()
        self.send_response(code); self._cors()
        self.send_header('Content-Type','application/json')
        self.send_header('Content-Length', len(body))
        self.end_headers(); self.wfile.write(body)
    def _cors(self):
        self.send_header('Access-Control-Allow-Origin','*')
        self.send_header('Access-Control-Allow-Methods','GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers','Content-Type')

def main():
    DATA_DIR.mkdir(exist_ok=True)
    write_signal('IDLE')
    print(f'[WATCHER] Port: {PORT}  Player: {find_player() or "none"}  Tracks: {len(scan_tracks())}')
    print(f'[WATCHER] Status: http://localhost:{PORT}/status')
    def shutdown(sig, frame): stop_player(); write_signal('IDLE'); sys.exit(0)
    signal.signal(signal.SIGINT, shutdown)
    signal.signal(signal.SIGTERM, shutdown)
    HTTPServer(('localhost', PORT), SignalHandler).serve_forever()

if __name__ == '__main__': main()
