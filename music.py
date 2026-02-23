function warpComplete() {
    // ... (previous stats logic)
    
    // LOGBOOK update
    addLog(`MISSION_SUCCESS: Session #${sessionCount} concluded.`);
    
    // AUTOPLAY: Triggers the stream. 
    // If no stream is selected, it defaults to NIGHTRIDE FM (Stream 0)
    const targetStream = currentStream === -1 ? 0 : currentStream;
    addLog(`AUTOPLAY_ENGAGED: Resuming Neural Stream...`);
    selectStream(targetStream); 

    // Visual Flash
    const ov = document.getElementById('warp-overlay');
    ov.classList.add('flash');
    setTimeout(() => ov.classList.remove('flash'), 1000);
}