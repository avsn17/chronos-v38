#!/bin/bash

# --- CONFIG & COLORS ---
HUD_FILE="index.html"
STATS_FILE="pilot_history.json"
GOLD='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}[IROH]: $1${NC}"; }

# --- THE ANIMATED FOCUS RING ---
# This function creates a rotating "Twirl" in the terminal
function draw_vortex() {
    local frames=('—' '\\' '|' '/')
    local frame_idx=$(( $1 % 4 ))
    echo -ne "${CYAN}${frames[$frame_idx]}${NC}"
}

# --- THE BREATHING BAR ---
# A progress bar that expands and contracts like lungs
function draw_lungs() {
    local width=$1
    local max=20
    local pulse=$(( (width % 10) ))
    if [ $pulse -gt 5 ]; then pulse=$(( 10 - pulse )); fi
    
    echo -ne "["
    for ((i=0; i<pulse+5; i++)); do echo -ne "—"; done
    echo -ne " 🔥 "
    for ((i=0; i<pulse+5; i++)); do echo -ne "—"; done
    echo -ne "]"
}

clear
iroh_say "The incense is lit. The terminal breathes with you."
read -p "CALLSIGN: " PILOT_NAME

while true; do
    iroh_say "Select Vibe: 1)CAS 2)Lana 3)BeeGees 4)URL [S]Stats [Q]Quit"
    read -p ">> " VIBE
    case $VIBE in
        1) MUSIC="CAS" ;; 2) MUSIC="LANA" ;; 3) MUSIC="BEEGEES" ;; 4) read -p "URL: " MUSIC ;;
        [Ss]*) python3 -m http.server 8080 & iroh_say "Dashboard: http://localhost:8080/stats.html"; continue ;;
        [Qq]*) pkill -f http.server; break ;;
        *) MUSIC="CAS" ;;
    esac

    iroh_say "Element: FIRE / WATER / EARTH / AIR / VOID"
    read -p ">> " THEME
    THEME=${THEME^^}

    # Inject to HUD
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE 2>/dev/null
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,} vortex-active\"/" $HUD_FILE 2>/dev/null

    iroh_say "Focusing the mind. What is your intent?"
    read -p ">> " AIM

    # --- THE IMMERSIVE TIMER LOOP ---
    seconds=$(( 25 * 60 ))
    total_secs=$seconds
    
    while [ $seconds -gt 0 ]; do
        mins=$((seconds / 60))
        secs=$((seconds % 60))
        
        # ANIMATION CALCULATIONS
        vortex_frame=$(draw_vortex $seconds)
        lungs=$(draw_lungs $seconds)
        
        # TERMINAL OUTPUT
        printf "\r${GOLD}[$vortex_frame]${NC} %02d:%02d $lungs ${RED}WARP_DRIVE${NC} | Vibe: ${CYAN}$MUSIC${NC} | $AIM " "$mins" "$secs"
        
        sleep 1
        : $((seconds--))
    done

    # --- SUCCESS RITUAL ---
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M')
    echo "{\"date\":\"$TIMESTAMP\", \"pilot\":\"$PILOT_NAME\", \"aim\":\"$AIM\", \"element\":\"$THEME\"}" >> $STATS_FILE
    echo "MISSION_SUCCESS" >> $HUD_FILE
    
    iroh_say "Excellent focus. The music is playing in your HUD tab."
    echo -e "${CYAN}--------------------------------------------------${NC}"
done
