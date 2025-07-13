#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'
echo -e "${CYAN}"
echo "   ██████╗ ██████╗ ██████╗ ██████╗ ███████╗ ██████╗██╗     ██╗███████╗███╗   ██╗████████╗"
echo "  ██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔════╝██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝"
echo "  ██║     ██║   ██║██████╔╝██║     █████╗  ██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   "
echo "  ██║     ██║   ██║██╔══██╗██║     ██╔══╝  ██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   "
echo "  ╚██████╗╚██████╔╝██║  ██║╚██████╗███████╗╚██████╗███████╗██║███████╗██║ ╚████║   ██║   "
echo "   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚══════╝ ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   "
echo -e "${MAGENTA}                  Programmed by NonNull${NC}"
echo -e "${BLUE}==================== CoreClient TPM-Scheduler Setup ===================${NC}"
echo -e "${YELLOW}Checking for pipx... (brought to you by NonNull)${NC}"
if ! command -v pipx >/dev/null 2>&1; then
  if [ -f /etc/debian_version ]; then
    echo -e "${YELLOW}pipx not found. Installing pipx with apt...${NC}"
    apt update && apt install -y pipx || { echo -e "${RED}Failed to install pipx with apt. Exiting.${NC}"; exit 1; }
    export PATH="$PATH:/root/.local/bin:/usr/local/bin"
    echo -e "${GREEN}pipx installed via apt. (NonNull made sure this works everywhere)${NC}"
  else
    echo -e "${YELLOW}pipx not found. Installing pipx with pip...${NC}"
    python3 -m pip install --user pipx --break-system-packages || python3 -m pip install --user pipx || { echo -e "${RED}Failed to install pipx with pip. Exiting.${NC}"; exit 1; }
    export PATH="$PATH:$(python3 -m site --user-base)/bin"
    echo -e "${GREEN}pipx installed via pip. (NonNull's magic)${NC}"
  fi
else
  echo -e "${GREEN}pipx is already installed. (NonNull approves)${NC}"
fi
echo -e "${YELLOW}Ensuring pipx path is set...${NC}"
ENSUREPATH_OUTPUT=$(pipx ensurepath 2>&1)
echo "$ENSUREPATH_OUTPUT" | grep -q 'new terminal' && {
  echo -e "${YELLOW}Notice: You may need to open a new terminal or re-login for PATH changes to take effect.${NC}"
}
export PATH="$PATH:$(python3 -m site --user-base)/bin:/root/.local/bin:/usr/local/bin"
echo -e "${YELLOW}Installing Python libraries from requirements.txt...${NC}"
if [ -f /etc/debian_version ]; then
  if [ "$(id -u)" -eq 0 ]; then
    python3 -m pip install --break-system-packages -r requirements.txt || { echo -e "${RED}Failed to install Python libraries. Exiting.${NC}"; exit 1; }
  else
    python3 -m pip install --user --break-system-packages -r requirements.txt || { echo -e "${RED}Failed to install Python libraries. Exiting.${NC}"; exit 1; }
  fi
else
  if [ "$(id -u)" -eq 0 ]; then
    python3 -m pip install -r requirements.txt || { echo -e "${RED}Failed to install Python libraries. Exiting.${NC}"; exit 1; }
  else
    python3 -m pip install --user -r requirements.txt || { echo -e "${RED}Failed to install Python libraries. Exiting.${NC}"; exit 1; }
  fi
fi
echo -e "${YELLOW}Making install_tpm.sh executable...${NC}"
chmod +x ./install_tpm.sh
echo -e "${YELLOW}Running TPM loader installer...${NC}"
./install_tpm.sh
echo -e "${YELLOW}Installing PyInstaller with pipx...${NC}"
pipx install --force pyinstaller || { echo -e "${RED}Failed to install pyinstaller with pipx. Exiting.${NC}"; exit 1; }
echo -e "${YELLOW}Building CoreClient TPM-Scheduler binary...${NC}"
pyinstaller tpm-scheduler.spec || { echo -e "${RED}PyInstaller build failed. Exiting.${NC}"; exit 1; }
echo -e "${YELLOW}Moving binary to project root...${NC}"
mv dist/tpm-scheduler . || { echo -e "${RED}Failed to move binary. Exiting.${NC}"; exit 1; }
echo -e "${YELLOW}Making binary executable...${NC}"
chmod +x tpm-scheduler

echo -e "${GREEN}\n==================== Setup Complete ==================="
echo -e "${CYAN}You can now start the app using ./tpm-scheduler${NC}"
echo -e "${MAGENTA}         Thank you for using CoreClient | Programmed by NonNull${NC}"
echo -e "${BLUE}   If this was smooth, that's the NonNull touch. Enjoy!${NC}"
echo -e "${YELLOW}\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${CYAN}Manual TPM configuration is required."
echo -e "Please follow the official guide in the CoreClient Discord:"
echo -e "${BLUE}https://discord.gg/VSBBfr5UTZ${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
echo -e "${GREEN}For 24/7 operation, run the automated service setup script:${NC}"
echo -e "${BLUE}   ./setup_service.sh${NC}"
echo -e "${CYAN}This will install and start the scheduler as a systemd service for you!${NC}\n"
chmod +x setup_service.sh