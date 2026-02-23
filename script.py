// --- SYSTEM STATE ---
let timerInterval = null;
let secondsLeft = 25 * 60;
const totalSeconds = 25 * 60;
let isRunning = false;

// Load Persistent Data
let pilotName = localStorage.getItem('sv38_pilot') || "";
let sessionCount = parseInt(localStorage.getItem('sv38_sessions') || '0');
let minuteCount = parseInt(localStorage.getItem('sv38_minutes') || '0');
let flightHistory = JSON.parse(localStorage.getItem('sv38_flights') || '[]');

// --- INITIALIZATION ---
window.onload = () => {
    document.getElementById('sessionCount').textContent = sessionCount;
    document.getElementById('minuteCount').textContent = minuteCount;
    if (pilotName) document.getElementById('pilotInput').value = pilotName;
    renderFlightHistory();
    addLog('SYSTEMS_ONLINE: Welcome back, Pilot.');
    updateArc();
};

// --- CORE FUNCTIONS ---
function updatePilot(v) {
    pilotName = v.toUpperCase();
    localStorage.setItem('sv38_pilot', pilotName);
}

function toggleWarp() {
    if (!isRunning) {
        startWarp();
    } else {
        stopWarp();
    }
}

function startWarp() {
    isRunning = true;
    const btn = document.getElementById('warpBtn');
    btn.textContent = 'ABORT_WARP';
    btn.classList.add('engaged');
    document.getElementById('pilotStatus').textContent = 'IN_WARP';
    addLog('Warp sequence initiated.');

    timerInterval = setInterval(() => {
        secondsLeft--;
        document.getElementById('timerDisplay').textContent = formatTime(secondsLeft);
        updateArc();
        if (secondsLeft <= 0) warpComplete();
    }, 1000);
}

function warpComplete() {
    clearInterval(timerInterval);
    isRunning = false;
    
    // Update Stats
    sessionCount++;
    minuteCount += 25;
    localStorage.setItem('sv38_sessions', sessionCount);
    localStorage.setItem('sv38_minutes', minuteCount);
    
    // Update UI
    document.getElementById('sessionCount').textContent = sessionCount;
    document.getElementById('minuteCount').textContent = minuteCount;
    
    // Log Flight
    const flight = { num: sessionCount, time: new Date().toLocaleTimeString(), dur: 25 };
    flightHistory.unshift(flight);
    localStorage.setItem('sv38_flights', JSON.stringify(flightHistory.slice(0, 10)));
    
    resetUI();
    renderFlightHistory();
    addLog(`Warp complete. Session #${sessionCount} logged.`);
    
    // Autoplay Music Logic (Triggers selection of current or random stream)
    if(currentStream !== -1) selectStream(currentStream);
}

// --- IROH WISDOM ENGINE (Zero-Latency Fallback) ---
const irohQuotes = [
    "While it is always best to believe in oneself, a little help from others can be a great blessing.",
    "Destiny is a funny thing. You never know how things are going to work out.",
    "It is important to draw wisdom from many different places.",
    "Follow your passion and life will reward you."
];

async function consultIroh() {
    const box = document.getElementById('irohBox');
    const btn = document.getElementById('irohBtn');
    btn.textContent = 'CHANNELING...';
    
    // Simulating "Network" delay for immersion
    setTimeout(() => {
        const quote = irohQuotes[Math.floor(Math.random() * irohQuotes.length)];
        box.textContent = quote;
        btn.textContent = 'CONSULT_IROH';
        addLog('Wisdom retrieved from archives.');
    }, 800);
}

// Helper: Format Time
function formatTime(s) {
    const m = Math.floor(s/60);
    return `${m.toString().padStart(2,'0')}:${(s%60).toString().padStart(2,'0')}`;
}

function resetUI() {
    secondsLeft = totalSeconds;
    document.getElementById('timerDisplay').textContent = "25:00";
    document.getElementById('warpBtn').textContent = 'ENGAGE_WARP';
    document.getElementById('warpBtn').classList.remove('engaged');
    document.getElementById('pilotStatus').textContent = 'STANDBY';
}