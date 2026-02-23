#!/bin/bash

# --- CONFIGURATION ---
HUD_FILE="index.html"
STATS_FILE="pilot_history.json"
GOLD='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}[IROH]: $1${NC}"; }

# --- THE STORYLINE & DIAGNOSTIC ---
clear
echo -e "${GOLD}📖 CHRONOS_V38: THE SOVEREIGN PATH${NC}"
iroh_say "Leaves from the vine, falling so slow... Welcome back, Pilot."
[ ! -f "$HUD_FILE" ] && echo -e "${RED}[!] Error: index.html not found.${NC}" && exit 1

read -p "Identify yourself for the White Lotus records: " PILOT_NAME
PILOT_NAME=${PILOT_NAME:-"Prince Zuko"}

while true; do
    iroh_say "Choose your focus music (Automated):\n1) Cigarettes After Sex\n2) Lana Del Rey\n3) Bee Gees\n4) Custom YouTube URL\n5) [S] View Spirit Dashboard\n6) [Q] Quit"
    read -p "VIBE SELECTION: " VIBE
    
    case $VIBE in
        1) MUSIC="CAS" ;;
        2) MUSIC="LANA" ;;
        3) MUSIC="BEEGEES" ;;
        4) read -p "Paste URL: " MUSIC ;;
        [Ss]*) pkill -f http.server; python3 -m http.server 8080 & iroh_say "Stats live at: http://localhost:8080/stats.html"; continue ;;
        [Qq]*) iroh_say "Safe travels."; pkill -f http.server; break ;;
        *) MUSIC="CAS" ;;
    esac

    iroh_say "Which element shall guide your animations?\n(FIRE / WATER / EARTH / AIR / VOID)"
    read -p "ELEMENT: " THEME
    THEME=${THEME^^}

    case $THEME in
        FIRE) HEX="#ff3860"; QUOTE="Power comes from the breath." ;;
        WATER) HEX="#3273dc"; QUOTE="Be like the river." ;;
        AIR) HEX="#00d1b2"; QUOTE="Let your worries float away." ;;
        VOID) HEX="#8a2be2"; QUOTE="Entering the Spirit World..." ;;
        *) HEX="#48c774"; THEME="EARTH"; QUOTE="Stand firm like a mountain." ;;
    esac

    # --- INJECT INTO HUD ---
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE
    sed -i "s/--glow: #.*;/--glow: $HEX;/" $HUD_FILE
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,} vortex-active\"/" $HUD_FILE

    iroh_say "$QUOTE\nWhat is your goal for this $THEME session?"
    read -p "INTENT: " AIM

    # --- THE TIMER ---
    seconds=$(( 25 * 60 ))
    while [ $seconds -gt 0 ]; do
        mins=$((seconds / 60))
        secs=$((seconds % 60))
        printf "\r${RED}[WARP]${NC} %02d:%02d | ${CYAN}$THEME${NC} | Vibe: ${BLUE}$MUSIC${NC} | Aim: $AIM " "$mins" "$secs"
        sleep 1
        : $((seconds--))
    done

    # --- LOGGING & MUSIC TRIGGER ---
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M')
    echo "{\"date\":\"$TIMESTAMP\", \"pilot\":\"$PILOT_NAME\", \"aim\":\"$AIM\", \"element\":\"$THEME\", \"vibe\":\"$MUSIC\"}" >> $STATS_FILE
    echo "MISSION_SUCCESS" >> $HUD_FILE
    
    iroh_say "Splendid work, $PILOT_NAME! The session is logged and your music is starting."
    iroh_say "Take a moment to enjoy your tea while the melody plays."
    echo "--------------------------------------------------------"
done
