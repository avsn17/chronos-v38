#!/bin/bash

# --- CONFIG & COLORS ---
HUD_FILE="index.html"
STATS_FILE="pilot_history.json"
GOLD='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}[IROH]: $1${NC}"; }

# --- ANIMATION: SPIRIT CASCADE (Final 60s) ---
function draw_cascade() {
    local chars=("0" "1" " " " " " " " " "茶" "🍵" "spirit" "void")
    local output=""
    for i in {1..5}; do
        output+="${chars[$RANDOM % ${#chars[@]}]} "
    done
    echo -ne "${GREEN}$output${NC}"
}

# --- ANIMATION: VORTEX SPINNER ---
function draw_vortex() {
    local frames=('—' '\\' '|' '/')
    echo -ne "${CYAN}${frames[$1 % 4]}${NC}"
}

# --- ANIMATION: BREATHING LUNGS ---
function draw_lungs() {
    local pulse=$(( ($1 % 10) ))
    [ $pulse -gt 5 ] && pulse=$(( 10 - pulse ))
    echo -ne "["
    for ((i=0; i<pulse+3; i++)); do echo -ne "—"; done
    echo -ne " 🔥 "
    for ((i=0; i<pulse+3; i++)); do echo -ne "—"; done
    echo -ne "]"
}

clear
iroh_say "The tea is at the perfect temperature. Welcome, Pilot."
read -p "IDENTIFY FOR LOGS: " PILOT_NAME

while true; do
    iroh_say "1) CAS | 2) LANA | 3) BEEGEES | 4) URL | [S] STATS | [Q] QUIT"
    read -p ">> " VIBE
    case $VIBE in
        1) MUSIC="CAS" ;; 2) MUSIC="LANA" ;; 3) MUSIC="BEEGEES" ;; 4) read -p "URL: " MUSIC ;;
        [Ss]*) pkill -f http.server; python3 -m http.server 8080 & iroh_say "Dashboard: http://localhost:8080/stats.html"; continue ;;
        [Qq]*) pkill -f http.server; break ;;
        *) MUSIC="CAS" ;;
    esac

    iroh_say "Element: FIRE / WATER / EARTH / AIR / VOID"
    read -p ">> " THEME
    THEME=${THEME^^}

    # Inject to HUD
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE 2>/dev/null
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,} vortex-active\"/" $HUD_FILE 2>/dev/null

    iroh_say "Intent for this $THEME warp?"
    read -p ">> " AIM

    # --- THE IMMERSIVE TIMER ---
    seconds=$(( 25 * 60 ))
    while [ $seconds -gt 0 ]; do
        mins=$((seconds / 60))
        secs=$((seconds % 60))
        
        vortex=$(draw_vortex $seconds)
        
        if [ $seconds -le 60 ]; then
            # FINAL MINUTE: Spirit Cascade Effect
            cascade=$(draw_cascade)
            printf "\r${GOLD}[$vortex]${NC} %02d:%02d | ${GREEN}TRANSITIONING...${NC} | $cascade " "$mins" "$secs"
        else
            # STANDARD FOCUS: Breathing Bar
            lungs=$(draw_lungs $seconds)
            printf "\r${GOLD}[$vortex]${NC} %02d:%02d $lungs ${RED}WARP_DRIVE${NC} | $AIM " "$mins" "$secs"
        fi
        
        sleep 1
        : $((seconds--))
    done

    # --- SUCCESS RITUAL ---
    echo "{\"date\":\"$(date)\", \"pilot\":\"$PILOT_NAME\", \"aim\":\"$AIM\", \"element\":\"$THEME\"}" >> $STATS_FILE
    echo "MISSION_SUCCESS" >> $HUD_FILE
    
    iroh_say "Warp successful. The veil has lifted. Enjoy the music."
    echo -e "${CYAN}--------------------------------------------------${NC}"
done
