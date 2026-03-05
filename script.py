// --- SYSTEM STATE ---
let timerInterval = null;
let secondsLeft = 25 * 60;
const totalSeconds = 25 * 60;
let isRunning = false;
let currentStream = -1; // was undefined before

// --- STORAGE HELPERS ---
const store = {
    get: (key, fallback) => {
        try { return JSON.parse(localStorage.getItem(key)) ?? fallback; }
        catch { return fallback; }
    },
    set: (key, val) => {
        try { localStorage.setItem(key, JSON.stringify(val)); }
        catch (e) { console.warn('Storage failed:', e); }
    }
};

// Load Persistent Data
let pilotName    = store.get('sv38_pilot', "");
let sessionCount = store.get('sv38_sessions', 0);
let minuteCount  = store.get('sv38_minutes', 0);
let flightHistory = store.get('sv38_flights', []);

// --- INITIALIZATION ---
window.onload = () => {
    document.getElementById('sessionCount').textContent = sessionCount;
    document.getElementById('minuteCount').textContent  = minuteCount;
    if (pilotName) document.getElementById('pilotInput').value = pilotName;
    renderFlightHistory();
    addLog('SYSTEMS_ONLINE: Welcome back, Pilot.');
    updateArc();
};

// --- CORE FUNCTIONS ---
function updatePilot(v) {
    pilotName = v.trim().toUpperCase();
    store.set('sv38_pilot', pilotName);
}

function toggleWarp() {
    isRunning ? stopWarp() : startWarp();
}

function startWarp() {
    if (isRunning) return; // guard against double-start
    isRunning = true;

    const btn = document.getElementById('warpBtn');
    btn.textContent = 'ABORT_WARP';
    btn.classList.add('engaged');
    document.getElementById('pilotStatus').textContent = 'IN_WARP';
    addLog('Warp sequence initiated.');

    timerInterval = setInterval(() => {
        if (--secondsLeft <= 0) { warpComplete(); return; }
        document.getElementById('timerDisplay').textContent = formatTime(secondsLeft);
        updateArc();
    }, 1000);
}

function stopWarp() {
    clearInterval(timerInterval);
    timerInterval = null;
    isRunning = false;
    resetUI();
    addLog('Warp aborted.');
}

function warpComplete() {
    clearInterval(timerInterval);
    timerInterval = null;
    isRunning = false;

    sessionCount++;
    minuteCount += 25;
    store.set('sv38_sessions', sessionCount);
    store.set('sv38_minutes',  minuteCount);

    document.getElementById('sessionCount').textContent = sessionCount;
    document.getElementById('minuteCount').textContent  = minuteCount;

    const flight = {
        num:  sessionCount,
        time: new Date().toLocaleTimeString(),
        dur:  25,
        pilot: pilotName || 'UNKNOWN'  // was missing before
    };
    flightHistory.unshift(flight);
    store.set('sv38_flights', flightHistory.slice(0, 10));

    resetUI();
    renderFlightHistory();
    addLog(`Warp complete. Session #${sessionCount} logged.`);

    if (currentStream !== -1) selectStream(currentStream);
}

// --- IROH WISDOM ENGINE ---
const irohQuotes = [
    "While it is always best to believe in oneself, a little help from others can be a great blessing.",
    "Destiny is a funny thing. You never know how things are going to work out.",
    "It is important to draw wisdom from many different places.",
    "Follow your passion and life will reward you."
];

async function consultIroh() {
    const box = document.getElementById('irohBox');
    const btn = document.getElementById('irohBtn');
    btn.disabled = true;
    btn.textContent = 'CHANNELING...';

    await new Promise(r => setTimeout(r, 800));

    const quote = irohQuotes[Math.floor(Math.random() * irohQuotes.length)];
    box.textContent = `"${quote}"`;  // added quotes for style
    btn.textContent = 'CONSULT_IROH';
    btn.disabled = false;
    addLog('Wisdom retrieved from archives.');
}

// --- HELPERS ---
function formatTime(s) {
    const m = Math.floor(s / 60);
    return `${String(m).padStart(2,'0')}:${String(s % 60).padStart(2,'0')}`;
}

function resetUI() {
    secondsLeft = totalSeconds;
    updateArc();
    document.getElementById('timerDisplay').textContent = formatTime(totalSeconds);
    const btn = document.getElementById('warpBtn');
    btn.textContent = 'ENGAGE_WARP';
    btn.classList.remove('engaged');
    document.getElementById('pilotStatus').textContent = 'STANDBY';
}