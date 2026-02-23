#!/bin/bash
HUD_FILE="index.html"
GOLD='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${GOLD}[IROH]: Each element has its own rhythm.${NC}"
read -p "PILOT CALLSIGN: " PILOT_NAME

while true; do
    echo -e "\n1) CAS | 2) LANA | 3) BEEGEES | 4) URL | [Q] QUIT"
    read -p "VIBE >> " VIBE
    case $VIBE in
        1) MUSIC="CAS" ;; 2) MUSIC="LANA" ;; 3) MUSIC="BEEGEES" ;; 
        [Qq]*) break ;; *) MUSIC="CAS" ;;
    esac

    echo -e "Choose Element: FIRE / WATER / EARTH / AIR / VOID"
    read -p "ELEMENT >> " THEME
    THEME=${THEME^^}

    read -p "INTENT >> " AIM

    # INJECT ANIMATION THEME
    # This specifically targets the class="hud ..." and changes it to the new element
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,}\"/" $HUD_FILE
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE
    sed -i "s/id=\"hud-intent\">.*<\/span>/id=\"hud-intent\">$AIM<\/span>/" $HUD_FILE

    echo -e "${CYAN}[SYSTEM]: $THEME animations engaged. Warp starting...${NC}"
    
    # 25 Minute Timer
    seconds=$(( 25 * 60 ))
    while [ $seconds -gt 0 ]; do
        printf "\r${GOLD}[WARP]${NC} %02d:%02d | Aim: $AIM " "$((seconds/60))" "$((seconds%60))"
        sleep 1
        : $((seconds--))
    done

    echo "MISSION_SUCCESS" >> $HUD_FILE
    echo -e "\n${GOLD}[IROH]: Excellent. Music is launching.${NC}"
done
