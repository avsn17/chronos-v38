#!/bin/bash

# --- CONFIGURATION ---
FILES=("index.html" "iroh_bot.sh" "pilot_history.json")
GOLD='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GOLD}[IROH]: Let us check the balance of your scrolls...${NC}\n"

# 1. Check for Files
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}[OK]${NC} $file is present in the workshop."
    else
        echo -e "${RED}[MISSING]${NC} $file is not here!"
        if [ "$file" == "pilot_history.json" ]; then
            echo -e "      Creating a new history log for you..."
            echo "[]" > pilot_history.json
        fi
    done

# 2. Check Permissions
if [ -x "iroh_bot.sh" ]; then
    echo -e "${GREEN}[OK]${NC} iroh_bot.sh has the authority to run."
else
    echo -e "${RED}[LOCKED]${NC} iroh_bot.sh needs permission."
    chmod +x iroh_bot.sh
    echo "      I have granted the permissions for you."
fi

# 3. Check for SED (The Twirl Engine)
if command -v sed &> /dev/null; then
    echo -e "${GREEN}[OK]${NC} The 'sed' engine is ready to twirl your CSS."
else
    echo -e "${RED}[ERROR]${NC} Your system is missing 'sed'. The HUD cannot change themes."
fi

echo -e "\n${GOLD}[IROH]: All systems are aligned. You are ready to engage the warp.${NC}"