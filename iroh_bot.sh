#!/bin/bash
HUD_FILE="index.html"
GOLD='\033[1;33m'
RED='\033[1;31m'
CYAN='\033[1;36m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}🍵 [IROH]: $1${NC}"; }

clear
echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║            CHRONOS V38: SOVEREIGN ZENITH             ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"

iroh_say "The tea is ready. Who leads the focus today?"
read -p ">> PILOT: " PILOT_NAME

while true; do
    sed -i '/MISSION_SUCCESS/d' $HUD_FILE

    echo -e "\n${CYAN}── NEURAL STREAM ──${NC}"
    echo -e "1. Cigarettes After Sex\n2. Lana Del Rey\n3. Bee Gees\n4. Custom YouTube URL\nQ. Quit"
    read -p ">> VIBE: " VIBE
    
    case $VIBE in
        1) MUSIC="CAS" ;; 2) MUSIC="LANA" ;; 3) MUSIC="BEEGEES" ;;
        4) read -p ">> PASTE URL: " MUSIC ;;
        [Qq]*) break ;; *) MUSIC="CAS" ;;
    esac

    iroh_say "For how many minutes shall we warp?"
    read -p ">> TIME (MINS): " DUR
    DUR=${DUR:-25}

    echo -e "\n${CYAN}── ELEMENTAL PHYSICS ──${NC}"
    echo -e "FIRE | WATER | EARTH | AIR | VOID"
    read -p ">> THEME: " THEME
    THEME=${THEME^^}

    iroh_say "Declare your intent to the world."
    read -p ">> INTENT: " AIM

    # ZENITH INJECTION
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,}\"/" $HUD_FILE
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE
    sed -i "s/id=\"hud-intent\">.*<\/span>/id=\"hud-intent\">$AIM<\/span>/" $HUD_FILE

    iroh_say "The $THEME path is open. Beginning $DUR minute focus."
    
    # ADVANCED TIMER
    seconds=$(( DUR * 60 ))
    total=$seconds
    while [ $seconds -gt 0 ]; do
        # Progress Bar Logic
        percent=$(( 100 - (100 * seconds / total) ))
        filled=$(( percent / 5 ))
        empty=$(( 20 - filled ))
        
        printf "\r${CYAN}WARP [${NC}"
        for ((i=0; i<filled; i++)); do printf "█"; done
        for ((i=0; i<empty; i++)); do printf "░"; done
        printf "${CYAN}]${NC} %02d:%02d | ${GOLD}$THEME${NC} | $AIM " "$((seconds/60))" "$((seconds%60))"
        
        sleep 1
        : $((seconds--))
    done

    echo "" >> $HUD_FILE
    iroh_say "Warp successful. Music initiated. Relax your mind, $PILOT_NAME."
done
