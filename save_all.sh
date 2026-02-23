#!/bin/bash
GOLD='\033[0;33m'
NC='\033[0m'

echo -e "${GOLD}[IROH]: Preservation is a form of respect for one's journey.${NC}"

# Ensure history exists so the zip isn't empty
[ ! -f "pilot_history.json" ] && echo "[]" > pilot_history.json

# Packaging the Sovereign System
zip -r chronos_v38_sovereign.zip index.html stats.html iroh_bot.sh diagnose.sh pilot_history.json README.md

echo -e "\n${GOLD}[IROH]: The scrolls are saved in 'chronos_v38_sovereign.zip'.${NC}"
echo -e "${GOLD}[IROH]: You may now push these to the Great Library (GitHub).${NC}"
