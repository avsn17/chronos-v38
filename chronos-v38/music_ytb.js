const MUSIC_MAP = {
    CAS:       'https://www.youtube.com/embed/L4vP7T9KoMo?autoplay=1&mute=0',
    LANA:      'https://www.youtube.com/embed/TdrLQxjyVw?autoplay=1&mute=0',
    BEEGEES:   'https://www.youtube.com/embed/I_izvAbhExY?autoplay=1&mute=0',
    NIGHTRIDE: 'https://www.youtube.com/embed/4xDzrJKXOOY?autoplay=1&mute=0',
    LOFI:      'https://www.youtube.com/embed/5qap5aO4i9A?autoplay=1&mute=0',
};

const MUSIC_KEYS = ['CAS','LANA','BEEGEES','NIGHTRIDE','LOFI'];
const MUSIC_NAMES = ['CAS FM','LANA DEL REY','BEE GEES','NIGHTRIDE FM','LOFI HIP-HOP'];

let activeMusic = 'CAS';
let musicPlaying = false;

function setActiveMusicKey(key) {
    if (MUSIC_MAP[key]) { activeMusic = key; }
}

function playAutomatedMusic() {
    const url = MUSIC_MAP[activeMusic] || MUSIC_MAP.CAS;
    const keyIndex = MUSIC_KEYS.indexOf(activeMusic);
    const name = keyIndex >= 0 ? MUSIC_NAMES[keyIndex] : 'CAS FM';
    
    if (typeof addLog === 'function') addLog('STREAM LIVE: ' + name);
    
    const player = document.getElementById('stream-player');
    const iframe  = document.getElementById('stream-iframe');
    const nameEl  = document.getElementById('stream-name-display');
    
    if (player && iframe) {
        iframe.src = url;
        player.style.display = 'flex';
        musicPlaying = true;
        if (nameEl) nameEl.textContent = name;
    }
    
    // Update status indicators
    const ms = document.getElementById('musicStatus');
    const ms2 = document.getElementById('musicStatus2');
    if (ms) ms.textContent = 'LIVE';
    if (ms2) ms2.textContent = 'LIVE';
}

function stopMusic() {
    const player = document.getElementById('stream-player');
    const iframe  = document.getElementById('stream-iframe');
    if (iframe) iframe.src = '';
    if (player) player.style.display = 'none';
    musicPlaying = false;
    
    // Reset status
    const ms = document.getElementById('musicStatus');
    const ms2 = document.getElementById('musicStatus2');
    if (ms) ms.textContent = 'OFF';
    if (ms2) ms2.textContent = 'OFF';
    
    if (typeof addLog === 'function') addLog('STREAM: STOPPED');
}

function closeStream() { stopMusic(); }
function pauseMusic()  { stopMusic(); }
function resumeMusic() { playAutomatedMusic(); }
