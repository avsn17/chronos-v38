#!/bin/bash
set -euo pipefail

# ═══════════════════════════════════════════════════════
#   IROH'S SANCTUARY — FOCUS TERMINAL v2.0
# ═══════════════════════════════════════════════════════

# --- CONSTANTS ---
HUD_FILE="${1:-index.html}"
LOG_FILE="mission_log.jsonl"
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$REPO_ROOT"

# --- COLORS & STYLE ---
GOLD='\033[1;33m'
CYAN='\033[1;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
DIM='\033[2m'
BOLD='\033[1m'
NC='\033[0m'

# --- GUARDS ---
if [[ ! -f "$HUD_FILE" ]]; then
    echo -e "${RED}[ERROR]${NC} HUD file '$HUD_FILE' not found." >&2
    exit 1
fi
if ! command -v sed &>/dev/null; then
    echo -e "${RED}[ERROR]${NC} 'sed' is required." >&2
    exit 1
fi

# --- HELPERS ---
divider() { echo -e "${DIM}    ────────────────────────────────────────${NC}"; }
log_json() {
    local pilot="$1" intent="$2" dur="$3" theme="$4" music="$5" status="$6"
    printf '{"pilot":"%s","intent":"%s","duration":%s,"theme":"%s","music":"%s","status":"%s","timestamp":"%s"}\n' \
        "$pilot" "$intent" "$dur" "$theme" "$music" "$status" \
        "$(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
}
inject_html() {
    local key="$1" val="$2"
    # Sanitize: escape & / for sed
    local safe_val
    safe_val=$(printf '%s' "$val" | sed 's/[&/\]/\\&/g')
    sed -i "s|id=\"${key}\">.*</span>|id=\"${key}\">${safe_val}</span>|" "$HUD_FILE"
}
cleanup_html() {
    sed -i '/SUNRISE_/d' "$HUD_FILE"
    sed -i '/MISSION_SUCCESS/d' "$HUD_FILE"
}

# ═══════════════════════════════════════════════════════
# BOOT SCREEN
# ═══════════════════════════════════════════════════════
clear
echo -e "
${GOLD}  ╔═══════════════════════════════════════════╗
  ║     IROH'S SANCTUARY — FOCUS TERMINAL     ║
  ╚═══════════════════════════════════════════╝${NC}
"
divider
read -rp "$(echo -e "    ${CYAN}PILOT CALLSIGN${NC} » ")" PILOT_NAME
PILOT_NAME="${PILOT_NAME:-UNKNOWN}"
PILOT_NAME="${PILOT_NAME^^}"  # uppercase

# ═══════════════════════════════════════════════════════
# MISSION LOOP
# ═══════════════════════════════════════════════════════
SESSION=0

while true; do
    (( SESSION++ )) || true
    echo -e "\n${GOLD}  ── MISSION #${SESSION} ──────────────────────────────${NC}\n"

    # --- VIBE SELECTION ---
    echo -e "    ${BOLD}NEURAL STREAM${NC}"
    echo -e "    ${DIM}[1]${NC} CAS FM   ${DIM}[2]${NC} LANA   ${DIM}[3]${NC} BEE GEES   ${DIM}[4]${NC} CUSTOM URL"
    read -rp "$(echo -e "    ${CYAN}VIBE${NC} » ")" VIBE
    case "${VIBE:-1}" in
        1) MUSIC="CAS"     ;;
        2) MUSIC="LANA"    ;;
        3) MUSIC="BEEGEES" ;;
        4) read -rp "$(echo -e "    ${CYAN}URL${NC} » ")" MUSIC ;;
        *) MUSIC="CAS"     ;;
    esac

    # --- MISSION PARAMS ---
    read -rp "$(echo -e "    ${CYAN}DURATION (mins)${NC} [25] » ")" DUR
    DUR="${DUR:-25}"
    if ! [[ "$DUR" =~ ^[0-9]+$ ]] || (( DUR < 1 || DUR > 180 )); then
        echo -e "    ${RED}Invalid duration. Defaulting to 25.${NC}"
        DUR=25
    fi

    echo -e "\n    ${BOLD}ELEMENT${NC}  fire · water · earth · air · void"
    read -rp "$(echo -e "    ${CYAN}ELEMENT${NC} » ")" THEME
    THEME="${THEME:-void}"
    THEME="${THEME^^}"

    read -rp "$(echo -e "    ${CYAN}INTENT${NC}  » ")" AIM
    AIM="${AIM:-FOCUS}"
    AIM="${AIM^^}"

    # --- HUD INJECTION ---
    cleanup_html
    sed -i "s|var activeMusic = \".*\";|var activeMusic = \"${MUSIC}\";|" "$HUD_FILE"
    inject_html "hud-intent" "$AIM"
    inject_html "pilot-id"   "$PILOT_NAME"
    inject_html "env-type"   "$THEME"

    divider
    echo -e "    ${GOLD}WARP ENGAGED${NC}  ·  ${AIM}  ·  ${DUR}m  ·  ${THEME}"
    divider

    # --- COUNTDOWN ---
    total=$(( DUR * 60 ))
    seconds=$total
    ABORTED=false

    # Trap Ctrl+C to abort gracefully
    trap 'ABORTED=true' INT

    while (( seconds > 0 )) && [[ "$ABORTED" == false ]]; do
        percent=$(( 100 * (total - seconds) / total ))
        mins=$(( seconds / 60 ))
        secs=$(( seconds % 60 ))

        # Progress bar (30 chars wide)
        filled=$(( percent * 30 / 100 ))
        bar=""
        for (( i=0; i<30; i++ )); do
            (( i < filled )) && bar+="█" || bar+="░"
        done

        printf "\r    ${GOLD}%02d:%02d${NC}  [${CYAN}%s${NC}]  %3d%%  ${DIM}%s${NC}  " \
            "$mins" "$secs" "$bar" "$percent" "$AIM"

        # Inject sunrise signal into HUD
        echo "<span class='sr-signal'>SUNRISE_${percent}</span>" >> "$HUD_FILE"

        sleep 1
        (( seconds-- )) || true
    done

    # Restore trap
    trap - INT
    echo ""

    # --- CLEANUP ---
    cleanup_html

    # --- OUTCOME ---
    if [[ "$ABORTED" == true ]]; then
        echo -e "\n    ${RED}[ABORTED]${NC} Mission cut short. The tea grows cold."
        log_json "$PILOT_NAME" "$AIM" "$DUR" "$THEME" "$MUSIC" "ABORTED"
    else
        # Mission success injection
        echo "<span id='mission-signal'>MISSION_SUCCESS</span>" >> "$HUD_FILE"
        log_json "$PILOT_NAME" "$AIM" "$DUR" "$THEME" "$MUSIC" "SUCCESS"

        echo -e "\n${GOLD}
  ╔═══════════════════════════════════════════╗
  ║   ✦  MISSION SUCCESS — SUN HAS RISEN  ✦  ║
  ║   Pilot : ${PILOT_NAME}
  ║   Intent: ${AIM}
  ║   Time  : ${DUR} minutes of pure focus.
  ╚═══════════════════════════════════════════╝${NC}"
    fi

    # --- NEXT MISSION? ---
    divider
    read -rp "$(echo -e "    ${CYAN}NEW MISSION?${NC} [Y/n] » ")" AGAIN
    [[ "${AGAIN:-Y}" =~ ^[Nn]$ ]] && break

done

echo -e "\n    ${GOLD}[IROH]: Until we meet again, Pilot. ☕${NC}\n"