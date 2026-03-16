const MUSIC_MAP = {
    CAS:       'https://www.youtube.com/embed/L4vP7T9KoMo?autoplay=1',
    LANA:      'https://www.youtube.com/embed/TdrL3QxjyVw?autoplay=1',
    BEEGEES:   'https://www.youtube.com/embed/I_izvAbhExY?autoplay=1',
    NIGHTRIDE: 'https://www.youtube.com/embed/4xDzrJKXOOY?autoplay=1',
    LOFI:      'https://www.youtube.com/embed/5qap5aO4i9A?autoplay=1',
};

let activeMusic = 'CAS';

function setActiveMusicKey(key) {
    if (MUSIC_MAP[key]) { activeMusic = key; }
}

function playAutomatedMusic() {
    const url = MUSIC_MAP[activeMusic] || MUSIC_MAP.CAS;
    if (typeof addLog === 'function') addLog('AUTOPLAY: ' + activeMusic + ' stream loading...');
    writeSignal('PLAY_NEXT');
    const player = document.getElementById('stream-player');
    const iframe  = document.getElementById('stream-iframe');
    if (player && iframe) {
        iframe.src = url;
        player.style.display = 'flex';
    }
}

function stopMusic() {
    writeSignal('STOP');
    const player = document.getElementById('stream-player');
    const iframe  = document.getElementById('stream-iframe');
    if (iframe) iframe.src = '';
    if (player) player.style.display = 'none';
    if (typeof addLog === 'function') addLog('MUSIC: STOP');
}

function closeStream() { stopMusic(); }
function pauseMusic()  { writeSignal('PAUSE'); }
function resumeMusic() { writeSignal('RESUME'); }

function writeSignal(action) {
    fetch('http://localhost:8765/signal', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action })
    }).catch(() => {});
}
