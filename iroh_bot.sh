#!/bin/bash

# --- CONFIG & COLORS ---
HUD_FILE="index.html"
STATS_FILE="pilot_history.json"
GOLD='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
PURPLE='\033[0;35m'
BLUE='\033[0;34m'
NC='\033[0m'

function iroh_say() { echo -e "\n${GOLD}[IROH]: $1${NC}"; }

# --- ANIMATION: SPIRIT CASCADE (Final 60s) ---
function draw_cascade() {
    local chars=("茶" "🍵" "☯" "✧" "⚡" "0" "1" "VOID" "IROH" "ZEN")
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
    [ $1 -le 300 ] && color=$RED 
    echo -ne "${color}["
    for ((i=0; i<pulse+5; i++)); do echo -ne "—"; done
    echo -ne " 🫖 "
    for ((i=0; i<pulse+5; i++)); do echo -ne "—"; done
    echo -ne "]${NC}"
}

# --- INITIALIZATION ---
clear
iroh_say "The tea is steeping. The world is quiet. Welcome, Sovereign Pilot."
read -p "IDENTIFY PILOT: " PILOT_NAME
PILOT_NAME=${PILOT_NAME:-"Traveler"}

while true; do
    echo -e "${CYAN}--------------------------------------------------${NC}"
    iroh_say "Select your Neural Stream (Music):"
    echo -e "1) Cigarettes After Sex\n2) Lana Del Rey\n3) Bee Gees\n4) Custom URL\n[S] Stats | [Q] Quit"
    read -p "VIBE >> " VIBE
    
    case $VIBE in
        1) MUSIC="CAS"; AMBIENT="Rain" ;;
        2) MUSIC="LANA"; AMBIENT="Wind" ;;
        3) MUSIC="BEEGEES"; AMBIENT="City Lights" ;;
        4) read -p "URL: " MUSIC; AMBIENT="Focus" ;;
        [Ss]*) pkill -f http.server; python3 -m http.server 8080 & iroh_say "Reflection: http://localhost:8080/stats.html"; continue ;;
        [Qq]*) pkill -f http.server; iroh_say "May you find balance on your journey."; break ;;
        *) MUSIC="CAS"; AMBIENT="Rain" ;;
    esac

    iroh_say "Which element governs this focus? (FIRE/WATER/EARTH/AIR/VOID)"
    read -p "ELEMENT >> " THEME
    THEME=${THEME^^}

    iroh_say "Set your focus intent (this will appear on the HUD):"
    read -p "INTENT >> " AIM

    # --- THE HUD INJECTION (The Secret Sauce) ---
    # Update Music, Theme, and Intent directly into index.html
    sed -i "s/var activeMusic = \".*\";/var activeMusic = \"$MUSIC\";/" $HUD_FILE 2>/dev/null
    sed -i "s/class=\"hud .*\"/class=\"hud theme-${THEME,,} vortex-active\"/" $HUD_FILE 2>/dev/null
    sed -i "s/id=\"hud-intent\">.*<\/span>/id=\"hud-intent\">$AIM<\/span>/" $HUD_FILE 2>/dev/null
    
    iroh_say "Beginning the $THEME warp. $AMBIENT sounds active in spirit."

    # --- THE MASTER TIMER ---
    seconds=$(( 25 * 60 ))
    while [ $seconds -gt 0 ]; do
        mins=$((seconds / 60))
        secs=$((seconds % 60))
        vortex_frames=('|' '/' '-' '\')
        vortex=${vortex_frames[$seconds % 4]}
        
        if [ $seconds -le 60 ]; then
            # FINAL 60 SECONDS: Spirit Cascade
            cascade=$(draw_cascade)
            printf "\r${PURPLE}[$vortex]${NC} %02d:%02d | ${PURPLE}VEIL THINNING${NC} | $cascade " "$mins" "$secs"
        else
            # FOCUS PERIOD: Breathing & Intent
            lungs=$(draw_lungs $seconds)
            printf "\r${GOLD}[$vortex]${NC} %02d:%02d $lungs | ${BLUE}Vibe: $AMBIENT${NC} | Aim: $AIM " "$mins" "$secs"
        fi
        
        sleep 1
        : $((seconds--))
    done

    # --- SUCCESS RITUAL ---
    # Log to History
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M')
    echo "{\"date\":\"$TIMESTAMP\", \"pilot\":\"$PILOT_NAME\", \"aim\":\"$AIM\", \"element\":\"$THEME\", \"music\":\"$MUSIC\"}" >> $STATS_FILE
    
    # Trigger Autoplay Signal in index.html (This assumes your JS is watching for changes)
    echo "" >> $HUD_FILE
    
    iroh_say "Focus complete, $PILOT_NAME. Music stream initiated. Enjoy your tea."
done
