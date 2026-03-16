// --- IROH'S AUTOMATED TURNTABLE ---
const MUSIC_MAP = {
    CAS:       'https://www.youtube.com/watch?v=L4vP7T9KoMo',
    LANA:      'https://www.youtube.com/watch?v=TdrL3QxjyVw',
    BEEGEES:   'https://www.youtube.com/watch?v=I_izvAbhExY',
    NIGHTRIDE: 'https://www.youtube.com/watch?v=4xDzrJKXOOY',
    LOFI:      'https://www.youtube.com/watch?v=5qap5aO4i9A',
};
let activeMusic = 'CAS';
let musicWindow = null;
function setActiveMusicKey(key) { if (MUSIC_MAP[key]) { activeMusic = key; writeSignal('IDLE'); } }
function playAutomatedMusic() {
    const url = MUSIC_MAP[activeMusic] || MUSIC_MAP.CAS;
    if (typeof addLog === 'function') addLog('AUTOPLAY: Launching ' + activeMusic + ' stream...');
    writeSignal('PLAY_NEXT');
    if (musicWindow && !musicWindow.closed) { musicWindow.location.href = url; }
    else { musicWindow = window.open(url, '_blank'); }
}
function stopMusic()   { writeSignal('STOP');   if (musicWindow && !musicWindow.closed) musicWindow.close(); musicWindow = null; }
function pauseMusic()  { writeSignal('PAUSE'); }
function resumeMusic() { writeSignal('RESUME'); }
function writeSignal(action) {
    fetch('http://localhost:8765/signal', {
        method: 'POST', headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ action })
    }).catch(() => {});
}
