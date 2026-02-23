#!/bin/bash

HUD_FILE="index.html"
STATS_FILE="pilot_history.json"
GOLD='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}[IROH]: $1${NC}"; }

clear
iroh_say "The tea is hot. Who is the pilot today?"
read -p "CALLSIGN: " PILOT_NAME
PILOT_NAME=${PILOT_NAME:-"Traveler"}

while true; do
    iroh_say "Choose your focus music vibe:\n1) CAS (Cigarettes After Sex)\n2) Lana Del Rey\n3) Bee Gees\n4) Custom URL\n5) View Dashboard (S)\n6) Quit (Q)"
    read -p "VIBE: " VIBE_CHOICE

    case $VIBE_CHOICE in
        1) MUSIC="CAS" ;;
        2) MUSIC="LANA" ;;
        3) MUSIC="BEEGEES" ;;
        4) read -p "Enter YouTube URL: " MUSIC ;;
        [Ss]*) pkill -f http.server; python3 -m http.server 8080 & echo "Stats: http://localhost:8080/stats.html"; continue ;;
        [Qq]*) pkill -f http.server; break ;;
        *) MUSIC="CAS" ;;
    esac

    iroh_say "Which element guides this session? (FIRE/WATER/EARTH/AIR/VOID)"
    read -p "ELEMENT: " THEME_NAME
    THEME_NAME=${THEME_NAME^^}
    
    # Inject Music and Theme into HUD
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME_NAME,,} vortex-active\"/" $HUD_FILE

    iroh_say "What is your goal for this $THEME_NAME session?"
    read -p "INTENT: " AIM

    # Timer Logic (25 min)
    seconds=$(( 25 * 60 ))
    while [ $seconds -gt 0 ]; do
        mins=$((seconds / 60))
        secs=$((seconds % 60))
        printf "\r${RED}[WARP]${NC} %02d:%02d | Vibe: $MUSIC | Aim: $AIM " "$mins" "$secs"
        sleep 1
        : $((seconds--))
    done

    # Mission Success
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M')
    echo "{\"date\":\"$TIMESTAMP\", \"pilot\":\"$PILOT_NAME\", \"music\":\"$MUSIC\", \"aim\":\"$AIM\"}" >> $STATS_FILE
    
    # Trigger Autoplay Signal
    echo "MISSION_SUCCESS" >> $HUD_FILE
    iroh_say "Warp complete. Your music should be starting now. Enjoy your tea, $PILOT_NAME."
done
