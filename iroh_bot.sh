#!/bin/bash

# --- CONFIG & COLORS ---
HUD_FILE="index.html"
STATS_FILE="pilot_history.json"
GOLD='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}[IROH]: $1${NC}"; }

# --- ANIMATION: SPIRIT CASCADE ---
function draw_cascade() {
    local chars=("茶" "🍵" "☯" "✧" "⚡" "0" "1" "SYSTEM" "VOID")
    local output=""
    for i in {1..8}; do
        output+="${chars[$RANDOM % ${#chars[@]}]} "
    done
    echo -ne "${PURPLE}$output${NC}"
}

# --- ANIMATION: BREATHING LUNGS ---
function draw_lungs() {
    local pulse=$(( ($1 % 10) ))
    [ $pulse -gt 5 ] && pulse=$(( 10 - pulse ))
    local color=$CYAN
    [ $1 -le 300 ] && color=$RED # Turn red in final 5 mins
    echo -ne "${color}["
    for ((i=0; i<pulse+4; i++)); do echo -ne "—"; done
    echo -ne " 🫖 "
    for ((i=0; i<pulse+4; i++)); do echo -ne "—"; done
    echo -ne "]${NC}"
}

clear
iroh_say "The workspace is an extension of the soul. Identify yourself, Pilot."
read -p ">> " PILOT_NAME

while true; do
    iroh_say "1) CAS | 2) LANA | 3) BEEGEES | 4) URL | [S] STATS | [Q] QUIT"
    read -p "VIBE >> " VIBE
    case $VIBE in
        1) MUSIC="CAS" ;; 2) MUSIC="LANA" ;; 3) MUSIC="BEEGEES" ;; 4) read -p "URL: " MUSIC ;;
        [Ss]*) pkill -f http.server; python3 -m http.server 8080 & iroh_say "Dashboard: http://localhost:8080/stats.html"; continue ;;
        [Qq]*) pkill -f http.server; break ;;
        *) MUSIC="CAS" ;;
    esac

    iroh_say "Element: FIRE / WATER / EARTH / AIR / VOID"
    read -p "ELEMENT >> " THEME
    THEME=${THEME^^}

    iroh_say "What is your focus intent?"
    read -p "INTENT >> " AIM

    # --- DEEP INJECTION INTO HUD ---
    # This pushes your actual text goal onto the HUD screen
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE 2>/dev/null
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,} vortex-active\"/" $HUD_FILE 2>/dev/null
    sed -i "s/id=\"hud-intent\">.*</id=\"hud-intent\">$AIM</" $HUD_FILE 2>/dev/null

    # --- THE TIMER ---
    seconds=$(( 25 * 60 ))
    while [ $seconds -gt 0 ]; do
        mins=$((seconds / 60))
        secs=$((seconds % 60))
        
        if [ $seconds -le 60 ]; then
            # FINAL MINUTE: Spirit Cascade
            cascade=$(draw_cascade)
            printf "\r${PURPLE}[⚡]${NC} %02d:%02d | ${PURPLE}THE VEIL THINS${NC} | $cascade " "$mins" "$secs"
        else
            # FOCUSING: Breathing Lungs
            lungs=$(draw_lungs $seconds)
            printf "\r${GOLD}[~]${NC} %02d:%02d $lungs | ${CYAN}$THEME ENERGY${NC} | Goal: $AIM " "$mins" "$secs"
        fi
        
        sleep 1
        : $((seconds--))
    done

    # --- LOGGING & AUTO-PLAY ---
    echo "{\"date\":\"$(date)\", \"pilot\":\"$PILOT_NAME\", \"aim\":\"$AIM\", \"element\":\"$THEME\"}" >> $STATS_FILE
    echo "MISSION_SUCCESS" >> $HUD_FILE
    
    iroh_say "Tea is poured. Music is live. Rest your mind, $PILOT_NAME."
    echo -e "${PURPLE}==================================================${NC}"
done
