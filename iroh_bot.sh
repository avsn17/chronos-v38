#!/bin/bash
HUD_FILE="index.html"
GOLD='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}[IROH]: $1${NC}"; }

clear
iroh_say "The mind is like this water, my friend. When it is agitated, it becomes difficult to see."
read -p "PILOT NAME: " PILOT_NAME

while true; do
    # RESET SIGNAL
    sed -i '/MISSION_SUCCESS/d' $HUD_FILE

    echo -e "\n1) CAS | 2) LANA | 3) BEEGEES | [Q] QUIT"
    read -p "VIBE >> " VIBE
    case $VIBE in
        1) MUSIC="CAS" ;; 2) MUSIC="LANA" ;; 3) MUSIC="BEEGEES" ;; 
        [Qq]*) break ;; *) MUSIC="CAS" ;;
    esac

    echo -e "ELEMENT: FIRE / WATER / EARTH / AIR / VOID"
    read -p "ELEMENT >> " THEME
    THEME=${THEME^^}

    read -p "WHAT IS YOUR INTENT? >> " AIM

    # LIVE INJECTION
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,}\"/" $HUD_FILE
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE
    sed -i "s/id=\"hud-intent\">.*<\/span>/id=\"hud-intent\">$AIM<\/span>/" $HUD_FILE

    iroh_say "The $THEME path is set. I will wake you when the tea is ready."
    
    # 25 Minute Focus Timer
    seconds=$(( 25 * 60 ))
    while [ $seconds -gt 0 ]; do
        printf "\r${CYAN}[WARP_DRIVE]${NC} %02d:%02d | ${GOLD}$THEME${NC} | $AIM " "$((seconds/60))" "$((seconds%60))"
        sleep 1
        : $((seconds--))
    done

    # TRIGGER MUSIC
    echo "" >> $HUD_FILE
    iroh_say "Warp complete. Your $MUSIC stream is launching. Rest your mind."
done
