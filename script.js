// --- SYSTEM STATE ---
let timerInterval = null;
let totalSeconds = 25 * 60;
let secondsLeft = totalSeconds;
let isRunning = false;
let currentStream = 0;
let currentStreamName = 'CAS FM';
let musicEnabled = true;
let themeIndex = 0;

const THEMES = ['void','fire','water','earth','air'];
const STREAMS = [
    { name:'CAS FM',       url:'https://www.youtube.com/watch?v=L4vP7T9KoMo' },
    { name:'LANA DEL REY', url:'https://www.youtube.com/watch?v=TdrL3QxjyVw' },
    { name:'BEE GEES',     url:'https://www.youtube.com/watch?v=I_izvAbhExY'  },
    { name:'NIGHTRIDE FM', url:'https://www.youtube.com/watch?v=4xDzrJKXOOY' },
    { name:'LOFI HIP-HOP', url:'https://www.youtube.com/watch?v=5qap5aO4i9A' },
];
const QUOTES = [
    "While it is always best to believe in oneself, a little help from others can be a great blessing.",
    "Destiny is a funny thing. You never know how things are going to work out.",
    "It is important to draw wisdom from many different places.",
    "Follow your passion and life will reward you.",
    "Sometimes the best way to solve your own problems is to help someone else.",
    "Silence is the first teacher. Pay attention.",
    "You must never give in to despair. Let your inner fire burn bright.",
    "Pride is not the opposite of shame, but its source.",
    "The greatest illusion of this world is the illusion of separation.",
    "There is nothing wrong with letting the people who love you help you.",
];
const CIRC = 2 * Math.PI * 90;

const store = {
    get: (k,fb) => { try { return JSON.parse(localStorage.getItem(k))??fb; } catch { return fb; } },
    set: (k,v)  => { try { localStorage.setItem(k,JSON.stringify(v)); } catch(e) { console.warn(e); } }
};

let pilotName    = store.get('sv38_pilot','');
let sessionCount = store.get('sv38_sessions',0);
let minuteCount  = store.get('sv38_minutes',0);
let flightHistory = store.get('sv38_flights',[]);

window.onload = () => {
    applyTheme('void');
    updateStats(); renderFlights();
    updateTimerDisplay(); updateArc(1); updateSunrise(0);
    if (pilotName) { setText('pilotDisplay',pilotName); setText('pilotInline',pilotName); setText('systemStatus','STANDBY · PILOT: '+pilotName); }
    renderWisdom();
    addLog('SYSTEMS_ONLINE');
    addLog('PRESS SPACE TO ENGAGE WARP');
    showModal('setup-modal');
};

function toggleWarp() { isRunning ? pauseWarp() : startWarp(); }

function startWarp() {
    if (isRunning) return;
    isRunning = true;
    setText('warpBtn','ABORT WARP [SPC]');
    getEl('warpBtn').classList.add('engaged');
    setText('systemStatus','IN_WARP · PILOT: '+(pilotName||'---'));
    addLog('WARP_SEQUENCE_INITIATED');
    timerInterval = setInterval(tick, 1000);
}

function pauseWarp() {
    clearInterval(timerInterval); timerInterval = null; isRunning = false;
    setText('warpBtn','RESUME WARP [SPC]');
    getEl('warpBtn').classList.remove('engaged');
    setText('systemStatus','PAUSED · PILOT: '+(pilotName||'---'));
    addLog('WARP_PAUSED');
}

function tick() {
    if (--secondsLeft <= 0) {
        secondsLeft = 0; updateTimerDisplay(); updateArc(0); updateSunrise(100);
        warpComplete(); return;
    }
    const p = secondsLeft / totalSeconds;
    updateTimerDisplay(); updateArc(p); updateSunrise((1-p)*100);
}

function resetTimer() {
    clearInterval(timerInterval); timerInterval = null; isRunning = false;
    secondsLeft = totalSeconds;
    updateTimerDisplay(); updateArc(1); updateSunrise(0);
    setText('warpBtn','ENGAGE WARP [SPC]');
    getEl('warpBtn').classList.remove('engaged');
    setText('systemStatus','STANDBY · PILOT: '+(pilotName||'---'));
    addLog('TIMER_RESET');
}

async function warpComplete() {
    clearInterval(timerInterval); timerInterval = null; isRunning = false;
    sessionCount++; minuteCount += Math.round(totalSeconds/60);
    store.set('sv38_sessions',sessionCount); store.set('sv38_minutes',minuteCount);
    flightHistory.unshift({num:sessionCount,time:new Date().toLocaleTimeString(),dur:Math.round(totalSeconds/60),pilot:pilotName||'UNKNOWN'});
    store.set('sv38_flights',flightHistory.slice(0,10));
    updateStats(); renderFlights();
    setText('warpBtn','ENGAGE WARP [SPC]');
    getEl('warpBtn').classList.remove('engaged');
    setText('systemStatus','MISSION_COMPLETE · PILOT: '+(pilotName||'---'));
    addLog('MISSION_SUCCESS — SESSION #'+sessionCount);
    addLog('+'+Math.round(totalSeconds/60)+'MIN · TOTAL: '+minuteCount+'MIN');
    setText('success-meta','PILOT: '+(pilotName||'UNKNOWN')+'  ·  SESSION #'+sessionCount+'  ·  '+Math.round(totalSeconds/60)+' MIN');
    setText('success-quote','"'+QUOTES[Math.floor(Math.random()*QUOTES.length)]+'"');
    showModal('success-modal');
    if (musicEnabled) {
        addLog('OPENING STREAM: '+currentStreamName);
        setTimeout(() => window.open(STREAMS[currentStream].url,'_blank'), 800);
    }
}

function updateSunrise(pct) {
    const r = document.documentElement;
    r.style.setProperty('--sun-y',(110-pct*0.75)+'%');
    r.style.setProperty('--sun-glow',(pct*2)+'px');
    const hg = getEl('horizon-glow'); if (hg) hg.style.opacity=(pct/100)*0.8;
    const st = getEl('stars'); if (st) st.style.opacity=1-(pct/100)*0.9;
}

function applyTheme(name,btn) {
    document.documentElement.setAttribute('data-theme',name);
    document.querySelectorAll('.el-btn').forEach(b=>b.classList.remove('active'));
    if (btn) btn.classList.add('active');
    else document.querySelectorAll('.el-btn').forEach(b=>{ if(b.dataset.theme===name) b.classList.add('active'); });
    themeIndex = THEMES.indexOf(name); if (themeIndex<0) themeIndex=0;
    addLog('ELEMENT: '+name.toUpperCase());
}

function cycleTheme() { themeIndex=(themeIndex+1)%THEMES.length; applyTheme(THEMES[themeIndex]); }

function selectStream(i,btn) {
    currentStream=i; currentStreamName=STREAMS[i].name;
    document.querySelectorAll('.st-btn').forEach(b=>b.classList.remove('active'));
    if (btn) btn.classList.add('active');
    else document.querySelectorAll('.st-btn')[i]?.classList.add('active');
    setText('streamStatus',currentStreamName);
    addLog('STREAM_QUEUED: '+currentStreamName);
}

function toggleMusic() {
    musicEnabled=!musicEnabled;
    addLog('MUSIC_SIGNAL: '+(musicEnabled?'ON':'OFF'));
    const el=getEl('musicStatus'); if (el) el.textContent=musicEnabled?'ON':'OFF';
}

function initMission() {
    const pilot  = (getEl('setup-pilot')?.value||'').trim().toUpperCase()||'PILOT';
    const intent = (getEl('setup-intent')?.value||'').trim().toUpperCase()||'FOCUS';
    const dur    = parseInt(getEl('setup-dur')?.value)||25;
    pilotName=pilot; store.set('sv38_pilot',pilotName);
    totalSeconds=dur*60; secondsLeft=totalSeconds;
    setText('intentDisplay',intent); setText('pilotDisplay',pilot);
    setText('pilotInline',pilot); setText('systemStatus','STANDBY · PILOT: '+pilot);
    if (getEl('live-intent')) getEl('live-intent').value=intent;
    if (getEl('live-dur'))    getEl('live-dur').value=dur;
    updateTimerDisplay(); updateArc(1); updateSunrise(0);
    hideModal('setup-modal');
    addLog('PILOT_'+pilot+'_ONLINE'); addLog('MISSION: '+intent); addLog('DURATION: '+dur+'MIN');
}

function applyParams() {
    if (isRunning) { addLog('CANNOT_CHANGE_PARAMS_DURING_WARP'); return; }
    const intent=(getEl('live-intent')?.value||'').trim().toUpperCase()||'FOCUS';
    const dur=parseInt(getEl('live-dur')?.value)||25;
    totalSeconds=dur*60; secondsLeft=totalSeconds;
    setText('intentDisplay',intent); updateTimerDisplay(); updateArc(1);
    addLog('PARAMS_UPDATED: '+intent+' · '+dur+'MIN');
}

function saveAndNew() {
    store.set('sv38_sessions',sessionCount); store.set('sv38_minutes',minuteCount); store.set('sv38_flights',flightHistory);
    addLog('SESSION_SAVED'); resetTimer(); hideAllModals(); showModal('setup-modal');
}

function saveAndQuit() {
    store.set('sv38_sessions',sessionCount); store.set('sv38_minutes',minuteCount); store.set('sv38_flights',flightHistory);
    addLog('FLIGHT_LOG_SAVED — FAREWELL, PILOT.');
    setTimeout(()=>window.close(),1200);
}

function showStats()      { updateStats(); renderFlights(); showModal('stats-modal');  addLog('STATS_OPENED'); }
function showConfig()     { showModal('config-modal');   addLog('CONFIG_OPENED'); }
function showWisdomChat() { renderWisdom(); showModal('wisdom-modal'); addLog('WISDOM_CHAT_OPENED'); }
function showModal(id)    { const m=getEl(id); if(m) m.style.display='flex'; }
function hideModal(id)    { const m=getEl(id); if(m) m.style.display='none'; }
function hideAllModals()  { ['setup-modal','stats-modal','config-modal','wisdom-modal','success-modal'].forEach(hideModal); }

async function consultIroh() {
    const box=getEl('irohBox'),btn=getEl('irohBtn');
    if (!box||!btn) return;
    btn.disabled=true; btn.textContent='CHANNELING...'; box.style.opacity='0';
    await delay(600);
    box.textContent='"'+QUOTES[Math.floor(Math.random()*QUOTES.length)]+'"';
    box.style.opacity='1'; btn.textContent='CONSULT IROH [C]'; btn.disabled=false;
    addLog('WISDOM_RETRIEVED');
}

function renderWisdom() {
    const box=getEl('irohBox');
    if (box) box.textContent='"'+QUOTES[Math.floor(Math.random()*QUOTES.length)]+'"';
}

function updateStats() {
    setText('stat-sessions',sessionCount); setText('stat-minutes',minuteCount);
    setText('sessionCount',sessionCount);  setText('minuteCount',minuteCount);
}
function renderFlights() {
    const el=getEl('flightHistory'); if (!el) return;
    el.innerHTML=flightHistory.slice(0,8).map(f=>
        `<div class="flt-entry"><span class="fn">#${f.num}</span><span>${f.dur}MIN</span><span>${f.pilot}</span><span style="opacity:0.4">${f.time}</span></div>`
    ).join('')||'<div style="opacity:0.4;font-size:0.5rem;padding:4px 0;">NO FLIGHTS YET</div>';
}
function addLog(msg) {
    const feed=getEl('log-feed'); if (!feed) return;
    const el=document.createElement('div'); el.className='log-entry new';
    const ts=new Date().toLocaleTimeString('en',{hour:'2-digit',minute:'2-digit',second:'2-digit'});
    el.innerHTML=`<span class="ts">${ts}</span>${msg}`;
    feed.prepend(el); setTimeout(()=>el.classList.remove('new'),2000);
    if (feed.children.length>60) feed.lastElementChild.remove();
}
function clearLog()   { const f=getEl('log-feed'); if(f) f.innerHTML=''; addLog('LOG_CLEARED'); }
function clearStats() {
    if (!confirm('Clear all mission stats?')) return;
    sessionCount=0; minuteCount=0; flightHistory=[];
    store.set('sv38_sessions',0); store.set('sv38_minutes',0); store.set('sv38_flights',[]);
    updateStats(); renderFlights(); addLog('STATS_CLEARED');
}
function exportLog() {
    const d=JSON.stringify({pilot:pilotName,sessions:sessionCount,minutes:minuteCount,flights:flightHistory},null,2);
    const a=document.createElement('a');
    a.href=URL.createObjectURL(new Blob([d],{type:'application/json'}));
    a.download='mission_log.json'; a.click(); addLog('FLIGHT_LOG_EXPORTED');
}

function getEl(id)      { return document.getElementById(id); }
function setText(id,t)  { const el=getEl(id); if(el) el.textContent=t; }
function updateTimerDisplay() { setText('timerDisplay',formatTime(secondsLeft)); }
function updateArc(f) {
    const arc=getEl('timer-arc');
    if (arc) { arc.style.strokeDasharray=CIRC; arc.style.strokeDashoffset=CIRC*(1-f); }
}
function formatTime(s) { return `${String(Math.floor(s/60)).padStart(2,'0')}:${String(s%60).padStart(2,'0')}`; }
const delay = ms => new Promise(r=>setTimeout(r,ms));

document.addEventListener('keydown', e => {
    const typing = ['INPUT','TEXTAREA','SELECT'].includes(document.activeElement.tagName);
    if (e.key==='Escape') { hideAllModals(); return; }
    if (typing) return;
    switch (e.key===' ' ? 'SPACE' : e.key.toUpperCase()) {
        case 'SPACE': e.preventDefault(); toggleWarp();    break;
        case 'C':     showWisdomChat();                    break;
        case 'S':     showStats();                         break;
        case 'A':     showConfig();                        break;
        case 'M':     toggleMusic();                       break;
        case 'O':     cycleTheme();                        break;
        case 'N':     saveAndNew();                        break;
        case 'Q':     saveAndQuit();                       break;
        case 'R':     resetTimer();                        break;
    }
});
