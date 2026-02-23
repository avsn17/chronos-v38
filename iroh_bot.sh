#!/bin/bash
HUD_FILE="index.html"
GOLD='\033[1;33m'
PINK='\033[1;35m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
NC='\033[0m'

clear
echo -e "${PINK}   ╔───────────────────────────────────────────╗${NC}"
echo -e "${PINK}   │   WELCOME TO THE WHITE LOTUS SUPERPORT    │${NC}"
echo -e "${PINK}   ╚───────────────────────────────────────────╝${NC}"

echo -e "${GOLD}[IROH]: Identify yourself for the history logs.${NC}"
read -p "   IDENT_ID >> " PILOT_NAME
PILOT_NAME=${PILOT_NAME^^}

while true; do
    sed -i '/MISSION_SUCCESS/d' $HUD_FILE

    echo -e "\n   ${CYAN}[1] CAS | [2] LANA | [3] BEEGEES | [4] URL${NC}"
    read -p "   SELECT_VIBE >> " VIBE
    case $VIBE in
        1) MUSIC="CAS" ;; 2) MUSIC="LANA" ;; 3) MUSIC="BEEGEES" ;;
        4) read -p "   PASTE_URL >> " MUSIC ;;
    esac

    read -p "   WARP_DURATION (MINS) >> " DUR
    DUR=${DUR:-25}

    echo -e "   ${GREEN}FIRE | WATER | EARTH | AIR | VOID${NC}"
    read -p "   ELEMENT_KEY >> " THEME
    THEME=${THEME^^}

    read -p "   DECLARE_INTENT >> " AIM

    # VIBRANT INJECTION
    sed -i "s/class=\"theme-.*\"/class=\"theme-${THEME,,}\"/" $HUD_FILE
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE
    sed -i "s/id=\"hud-intent\">.*<\/span>/id=\"hud-intent\">$AIM<\/span>/" $HUD_FILE
    sed -i "s/id=\"pilot-id\">.*<\/span>/id=\"pilot-id\">$PILOT_NAME<\/span>/" $HUD_FILE
    sed -i "s/id=\"env-type\">.*<\/span>/id=\"env-type\">$THEME<\/span>/" $HUD_FILE

    echo -e "\n${PINK}   [SYSTEM]: INITIALIZING NEURAL LINKS... SUCCESS.${NC}"
    
    seconds=$(( DUR * 60 ))
    total=$seconds
    while [ $seconds -gt 0 ]; do
        percent=$(( 100 - (100 * seconds / total) ))
        filled=$(( percent / 4 ))
        empty=$(( 25 - filled ))
        
        printf "\r   ${GREEN}FOCUS_LEVEL [${NC}"
        for ((i=0; i<filled; i++)); do printf "■"; done
        for ((i=0; i<empty; i++)); do printf " "; done
        printf "${GREEN}]${NC} %02d:%02d | ${GOLD}$THEME${NC} | $PILOT_NAME " "$((seconds/60))" "$((seconds%60))"
        
        sleep 1
        : $((seconds--))
    done

    echo "" >> $HUD_FILE
    echo -e "\n\n${PINK}   [SYSTEM]: WARP COMPLETE. AUTOPLAY INITIATED.${NC}"
done
