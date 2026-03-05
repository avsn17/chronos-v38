#!/bin/bash
set -euo pipefail

# --- CONFIGURATION ---
FILES=("index.html" "iroh_bot.sh" "pilot_history.json")
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GOLD='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

log_ok()   { echo -e "${GREEN}[OK]${NC}      $1"; }
log_err()  { echo -e "${RED}[MISSING]${NC} $1"; ((ERRORS++)) || true; }
log_warn() { echo -e "${CYAN}[FIXED]${NC}   $1"; ((WARNINGS++)) || true; }

echo -e "${GOLD}[IROH]: Let us check the balance of your scrolls...${NC}\n"
cd "$REPO_ROOT"

# --- 1. FILE CHECK ---
for file in "${FILES[@]}"; do
    if [[ -f "$file" ]]; then
        log_ok "$file present. Size: $(du -h "$file" | cut -f1)"
    else
        log_err "$file is missing!"
        if [[ "$file" == "pilot_history.json" ]]; then
            echo "[]" > pilot_history.json
            log_warn "Created empty pilot_history.json"
        fi
    fi
done

# --- 2. PERMISSION CHECK ---
if [[ -x "iroh_bot.sh" ]]; then
    log_ok "iroh_bot.sh has execute permission."
else
    chmod +x iroh_bot.sh
    log_warn "Granted execute permission to iroh_bot.sh"
fi

# --- 3. DEPENDENCY CHECK ---
DEPS=("sed" "curl" "jq")
for cmd in "${DEPS[@]}"; do
    if command -v "$cmd" &>/dev/null; then
        log_ok "'$cmd' found at $(command -v "$cmd")"
    else
        log_err "'$cmd' is not installed — some features will not work."
    fi
done

# --- 4. JSON VALIDATION ---
if [[ -f "pilot_history.json" ]]; then
    if jq empty pilot_history.json 2>/dev/null; then
        log_ok "pilot_history.json is valid JSON."
    else
        log_err "pilot_history.json is corrupted!"
        cp pilot_history.json "pilot_history.json.bak.$(date +%s)"
        echo "[]" > pilot_history.json
        log_warn "Reset pilot_history.json (backup saved)."
    fi
fi

# --- 5. GIT STATUS ---
if git rev-parse --git-dir &>/dev/null; then
    BRANCH=$(git branch --show-current)
    DIRTY=$(git status --porcelain | wc -l | tr -d ' ')
    log_ok "Git repo on branch: $BRANCH ($DIRTY uncommitted change(s))"
else
    echo -e "${CYAN}[INFO]${NC}    Not a git repository — skipping git check."
fi

# --- SUMMARY ---
echo -e "\n${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
if [[ $ERRORS -eq 0 ]]; then
    echo -e "${GREEN}[IROH]: All systems aligned. Engage the warp.${NC}"
else
    echo -e "${RED}[IROH]: $ERRORS issue(s) detected. Resolve before warping.${NC}"
    exit 1
fi
echo -e "${GOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"