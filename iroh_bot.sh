#!/bin/bash
HUD_FILE="index.html"
GOLD='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

clear
echo -e "${GOLD}    [ IROH'S SANCTUARY & FOCUS TERMINAL ]${NC}"
read -p "    >> PILOT: " PILOT_NAME

while true; do
    sed -i '/MISSION_SUCCESS/d' $HUD_FILE
    sed -i '/PERCENT:/d' $HUD_FILE

    echo -e "\n    NEURAL_STREAM: [1] CAS | [2] LANA | [3] BEEGEES | [4] URL"
    read -p "    >> VIBE: " VIBE
    case $VIBE in 1) MUSIC="CAS";; 2) MUSIC="LANA";; 3) MUSIC="BEEGEES";; 4) read -p "    >> URL: " MUSIC;; esac

    read -p "    >> TIME (MINS): " DUR
    DUR=${DUR:-25}
    echo -e "    ELEMENT: FIRE | WATER | EARTH | AIR | VOID"
    read -p "    >> KEY: " THEME
    read -p "    >> INTENT: " AIM

    # INITIAL INJECTION
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE
    sed -i "s/id=\"hud-intent\">.*<\/span>/id=\"hud-intent\">$AIM<\/span>/" $HUD_FILE
    sed -i "s/id=\"pilot-id\">.*<\/span>/id=\"pilot-id\">$PILOT_NAME<\/span>/" $HUD_FILE
    sed -i "s/id=\"env-type\">.*<\/span>/id=\"env-type\">$THEME<\/span>/" $HUD_FILE

    seconds=$(( DUR * 60 ))
    total=$seconds
    while [ $seconds -gt 0 ]; do
        percent=$(( 100 - (100 * seconds / total) ))
        
        # Injects Percent into HTML for JS Sunrise
        sed -i "/" >> $HUD_FILE
        
        # Terminal Progress
        printf "\r    WARP: %02d:%02d | SUNRISE: %d%% | ${GOLD}$AIM${NC} " "$((seconds/60))" "$((seconds%60))" "$percent"
        
        sleep 1
        : $((seconds--))
    done

    echo "" >> $HUD_FILE
    echo "" >> $HUD_FILE
    echo -e "\n\n${GOLD}    [SUCCESS] The sun has risen. Music is live.${NC}"
done
