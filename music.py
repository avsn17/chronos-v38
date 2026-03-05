async function warpComplete() {
    clearInterval(timerInterval);
    timerInterval = null;
    isRunning = false;

    // --- STATS ---
    sessionCount++;
    minuteCount += 25;
    store.set('sv38_sessions', sessionCount);
    store.set('sv38_minutes',  minuteCount);
    document.getElementById('sessionCount').textContent = sessionCount;
    document.getElementById('minuteCount').textContent  = minuteCount;

    const flight = {
        num:    sessionCount,
        time:   new Date().toLocaleTimeString(),
        dur:    25,
        pilot:  pilotName || 'UNKNOWN'
    };
    flightHistory.unshift(flight);
    store.set('sv38_flights', flightHistory.slice(0, 10));
    renderFlightHistory();

    // --- SEQUENCE: staged cinematic completion ---
    await runCompletionSequence();

    // --- AUTOPLAY ---
    const targetStream = currentStream === -1 ? 0 : currentStream;
    selectStream(targetStream);

    resetUI();
}

async function runCompletionSequence() {
    const overlay  = document.getElementById('warp-overlay');
    const portal   = document.getElementById('hud-intent');
    const status   = document.getElementById('pilotStatus');
    const timer    = document.getElementById('timerDisplay');

    // Step 1: White flash
    overlay.style.cssText = `
        position: fixed; inset: 0; z-index: 999;
        background: white; opacity: 0;
        transition: opacity 0.15s ease;
        pointer-events: none;
    `;
    await nextFrame();
    overlay.style.opacity = '1';
    await delay(150);
    overlay.style.opacity = '0';
    await delay(300);

    // Step 2: Timer slams to 00:00 with shake
    timer.textContent = '00:00';
    timer.animate([
        { transform: 'translateX(-6px)' },
        { transform: 'translateX(6px)'  },
        { transform: 'translateX(-4px)' },
        { transform: 'translateX(4px)'  },
        { transform: 'translateX(0)'    }
    ], { duration: 350, easing: 'ease-out' });
    await delay(400);

    // Step 3: Status cycles through completion states
    const states = [
        'WARP_COMPLETE',
        `SESSION_#${sessionCount}_LOGGED`,
        'NEURAL_STREAM_RESUMING',
        'STANDBY'
    ];
    for (const state of states) {
        status.textContent = state;
        status.style.color = state === 'STANDBY' ? '' : '#d4af37';
        await delay(600);
    }

    // Step 4: Portal message with typewriter effect
    await typewriter(portal, `MISSION_SUCCESS`, 60);
    await delay(800);
    await typewriter(portal, `PILOT_${pilotName || 'UNKNOWN'}_DISTINGUISHED`, 40);
    await delay(1000);
    portal.textContent = 'AWAITING_SPIRIT';

    // Step 5: Gold border pulse on sanctuary
    const sanctuary = document.getElementById('canvas');
    sanctuary.animate([
        { boxShadow: 'inset 0 0 0px #d4af37'   },
        { boxShadow: 'inset 0 0 60px #d4af37'  },
        { boxShadow: 'inset 0 0 120px #d4af37' },
        { boxShadow: 'inset 0 0 0px #d4af37'   }
    ], { duration: 1200, easing: 'ease-in-out' });

    // Step 6: Log entries staggered
    const logs = [
        `MISSION_SUCCESS ── Session #${sessionCount} concluded.`,
        `FLIGHT_TIME ── +25min │ Total: ${minuteCount}min`,
        `AUTOPLAY_ENGAGED ── Resuming neural stream...`
    ];
    for (const msg of logs) {
        addLog(msg);
        await delay(300);
    }

    await delay(200);
}

// --- UTILS ---
const delay = ms => new Promise(r => setTimeout(r, ms));
const nextFrame = () => new Promise(r => requestAnimationFrame(r));

async function typewriter(el, text, speed = 60) {
    el.textContent = '';
    for (const char of text) {
        el.textContent += char;
        await delay(speed);
    }
}