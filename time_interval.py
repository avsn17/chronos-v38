if (secondsLeft === 60) {
    document.querySelector('.hud').classList.add('low-power');
    addLog('CRITICAL: Low power mode engaged. 60s to exit.');
}