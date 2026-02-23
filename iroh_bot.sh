#!/bin/bash
HUD_FILE="index.html"
GOLD='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}[IROH]: $1${NC}"; }

clear
iroh_say "A wise man knows that time is as fluid as the river. Who is the pilot today?"
read -p "CALLSIGN >> " PILOT_NAME

while true; do
    # RESET SIGNAL
    sed -i '/MISSION_SUCCESS/d' $HUD_FILE

    echo -e "\n${CYAN}--- NEURAL STREAM SELECTION ---${NC}"
    echo -e "1) Cigarettes After Sex\n2) Lana Del Rey\n3) Bee Gees\n4) Custom YouTube URL\n[Q] Quit"
    read -p "SELECTION >> " VIBE
    
    case $VIBE in
        1) MUSIC="CAS" ;;
        2) MUSIC="LANA" ;;
        3) MUSIC="BEEGEES" ;;
        4) read -p "PASTE YOUTUBE URL >> " MUSIC ;;
        [Qq]*) break ;;
        *) MUSIC="CAS" ;;
    esac

    iroh_say "How many minutes shall this focus session last?"
    read -p "MINUTES >> " DUR
    DUR=${DUR:-25} # Default to 25 if empty

    echo -e "ELEMENT: FIRE / WATER / EARTH / AIR / VOID"
    read -p "THEME >> " THEME
    THEME=${THEME^^}

    read -p "WHAT IS YOUR INTENT? >> " AIM

    # LIVE INJECTION
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,}\"/" $HUD_FILE
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE
    sed -i "s/id=\"hud-intent\">.*<\/span>/id=\"hud-intent\">$AIM<\/span>/" $HUD_FILE

    iroh_say "The path of $THEME is set for $DUR minutes. Focus your breath."
    
    # DYNAMIC TIMER
    seconds=$(( DUR * 60 ))
    while [ $seconds -gt 0 ]; do
        printf "\r${CYAN}[WARP]${NC} %02d:%02d | ${GOLD}$THEME${NC} | $AIM " "$((seconds/60))" "$((seconds%60))"
        sleep 1
        : $((seconds--))
    done

    # TRIGGER MUSIC
    echo "" >> $HUD_FILE
    iroh_say "The $DUR minutes have passed. Your music is launching. Enjoy the tea."
done
