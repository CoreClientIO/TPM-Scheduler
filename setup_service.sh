#!/bin/bash
set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

SERVICE_NAME="tpm-scheduler"
BINARY_PATH="/usr/local/bin/tpm-scheduler"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
WORKDIR="$(pwd)"

clear
echo -e "${CYAN}"
echo "   ██████╗ ██████╗ ██████╗ ███████╗ ██████╗██╗     ██╗███████╗███╗   ██╗████████╗"
echo "  ██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝"
echo "  ██║     ██║   ██║██████╔╝█████╗  ██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   "
echo "  ██║     ██║   ██║██╔══██╗██╔══╝  ██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   "
echo "  ╚██████╗╚██████╔╝██║  ██║███████╗╚██████╗███████╗██║███████╗██║ ╚████║   ██║   "
echo "   ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝ ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   "
echo -e "${MAGENTA}                  Programmed by NonNull${NC}"
echo -e "${BLUE}========== CoreClient TPM-Scheduler Service Setup ==========${NC}"

echo -e "${YELLOW}🔎 Checking for config.json...${NC}"
if [ ! -f "config.json" ]; then
  echo -e "${RED}config.json not found in this directory!${NC}"
  echo -e "${YELLOW}Please run ./tpm-scheduler once manually to set up your configuration before running this script.${NC}"
  exit 1
fi

echo -e "${YELLOW}🔎 Checking for config.json5...${NC}"
if [ -f "config.json5" ]; then
  echo -e "${YELLOW}Copying config.json5 to /usr/local/bin/...${NC}"
  sudo cp config.json5 /usr/local/bin/
fi

echo -e "${YELLOW}🔎 Moving tpm-scheduler binary to ${BINARY_PATH}...${NC}"
if [ -f "tpm-scheduler" ]; then
  sudo mv tpm-scheduler "$BINARY_PATH"
  sudo chmod +x "$BINARY_PATH"
else
  echo -e "${RED}tpm-scheduler binary not found in current directory. Exiting.${NC}"
  exit 1
fi

echo -e "${YELLOW}📝 Creating systemd service file at ${SERVICE_FILE}...${NC}"
SERVICE_CONTENT="[Unit]
Description=CoreClient TPM-Scheduler
After=network.target

[Service]
Type=simple
User=$(whoami)
WorkingDirectory=${WORKDIR}
ExecStart=${BINARY_PATH}
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
"
echo "$SERVICE_CONTENT" | sudo tee "$SERVICE_FILE" > /dev/null

echo -e "${YELLOW}🔄 Reloading systemd, enabling and starting the service...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

# Overview of commands
echo -e "\n${GREEN}==================== 🎉 Service Setup Complete 🎉 ==================="
echo -e "${CYAN}Your CoreClient TPM-Scheduler is now running as a systemd service!${NC}"
echo -e "${YELLOW}\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}🛠️  Useful commands:${NC}"
echo -e "  ${GREEN}🔄 Restart service:${NC}   sudo systemctl restart $SERVICE_NAME"
echo -e "  ${GREEN}🛑 Stop service:${NC}      sudo systemctl stop $SERVICE_NAME"
echo -e "  ${GREEN}▶️  Start service:${NC}     sudo systemctl start $SERVICE_NAME"
echo -e "  ${GREEN}ℹ️  Status:${NC}           systemctl status $SERVICE_NAME"
echo -e "  ${GREEN}📜 Logs:${NC}             journalctl -u $SERVICE_NAME -f"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
echo -e "${MAGENTA}         Thank you for using CoreClient | Programmed by NonNull${NC}"
echo -e "${BLUE}   If this was smooth, that's the NonNull touch. Enjoy!${NC}" 