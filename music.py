#!/usr/bin/env python3
"""
music.py - Iroh's Music CLI
Usage:
  python3 music.py play    # PLAY_NEXT
  python3 music.py stop    # STOP
  python3 music.py pause   # PAUSE
  python3 music.py resume  # RESUME
  python3 music.py status  # watcher status
  python3 music.py list    # list tracks in data/
"""
import sys, json, urllib.request
from pathlib import Path

WATCHER  = 'http://localhost:8765'
DATA_DIR = Path('data')

def send(action):
    try:
        req = urllib.request.Request(f'{WATCHER}/signal',
            data=json.dumps({'action':action}).encode(),
            headers={'Content-Type':'application/json'}, method='POST')
        with urllib.request.urlopen(req, timeout=2) as r:
            print(f'[OK] {json.loads(r.read())}')
    except Exception as e:
        print(f'[ERROR] Watcher not running: {e}')
        print('        Start it: python3 music_watcher.py &')

def status():
    try:
        with urllib.request.urlopen(f'{WATCHER}/status', timeout=2) as r:
            for k,v in json.loads(r.read()).items(): print(f'  {k:10} {v}')
    except Exception as e: print(f'[ERROR] {e}')

def list_tracks():
    tracks = []
    for ext in ('*.mp3','*.ogg','*.flac','*.wav','*.m4a'):
        tracks.extend(sorted(DATA_DIR.glob(ext)))
    print(f'{len(tracks)} tracks in data/:')
    for t in tracks: print(f'  {t}')

cmd = sys.argv[1] if len(sys.argv) > 1 else 'status'
{'play':lambda:send('PLAY_NEXT'),'stop':lambda:send('STOP'),
 'pause':lambda:send('PAUSE'),'resume':lambda:send('RESUME'),
 'status':status,'list':list_tracks}.get(cmd, lambda: print(f'Unknown: {cmd}'))()
