// --- IROH'S AUTOMATED TURNTABLE ---
var activeMusic = "CAS"; // Managed by the Bot

function playAutomatedMusic() {
    const musicMap = {
        "CAS": "https://www.youtube.com/watch?v=L4vP7T9KoMo",
        "LANA": "https://www.youtube.com/watch?v=TdrL3QxjyVw",
        "BEEGEES": "https://www.youtube.com/watch?v=I_izvAbhExY"
    };

    let targetUrl = musicMap[activeMusic] || activeMusic; // Use map or direct URL
    
    addLog(`SYSTEM: Launching ${activeMusic} stream...`);
    window.open(targetUrl, '_blank');
}

// This function should be called inside your warpComplete() or when MISSION_SUCCESS is detected
if (missionSuccessDetected) {
    playAutomatedMusic();
}