#!/bin/bash

# --- CONFIGURATION ---
HUD_FILE="index.html"
STATS_FILE="pilot_history.json"
GOLD='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

function iroh_say() {
    echo -e "\n${GOLD}[IROH]: $1${NC}"
}

clear
iroh_say "Welcome, Sovereign Pilot. The tea is hot and the path is clear."
read -p "Who is the pilot for the logs? " PILOT_NAME
PILOT_NAME=${PILOT_NAME:-"Traveler"}

while true; do
    iroh_say "Would you like to (C)ontinue focus, (S)ee Dashboard, or (Q)uit?"
    read -p "CHOICE: " NEXT

    if [[ "$NEXT" =~ ^[Ss] ]]; then
        iroh_say "Opening the Spirit World reflections..."
        pkill -f http.server 2>/dev/null
        python3 -m http.server 8080 & 
        echo -e ">>> View stats at: http://localhost:8080/stats.html"
        read -n 1 -s -p "Press any key to return..."
    elif [[ "$NEXT" =~ ^[Qq] ]]; then
        iroh_say "Safe travels, $PILOT_NAME."
        pkill -f http.server 2>/dev/null
        break
    elif [[ "$NEXT" =~ ^[Cc] ]]; then
        iroh_say "Which element guides you? (FIRE/WATER/EARTH/AIR/VOID)"
        read -p "ELEMENT: " THEME_NAME
        THEME_NAME=${THEME_NAME^^}
        sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME_NAME,,} vortex-active\"/" $HUD_FILE 2>/dev/null
        iroh_say "Aiming for 25 minutes. What is your goal?"
        read -p "INTENT: " AIM
        seconds=$(( 25 * 60 ))
        while [ $seconds -gt 0 ]; do
            mins=$((seconds / 60))
            secs=$((seconds % 60))
            printf "\r${RED}[WARP]${NC} %02d:%02d | Aim: $AIM " "$mins" "$secs"
            sleep 1
            : $((seconds--))
        done
        TIMESTAMP=$(date +'%Y-%m-%d %H:%M')
        echo "{\"date\":\"$TIMESTAMP\", \"pilot\":\"$PILOT_NAME\", \"aim\":\"$AIM\", \"element\":\"$THEME_NAME\"}" >> $STATS_FILE
        echo "MISSION_SUCCESS" >> $HUD_FILE
        iroh_say "Excellent work! The music is playing."
    fi
done
