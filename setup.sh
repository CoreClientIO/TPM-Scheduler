#!/bin/bash
set -e
echo "\n========== CoreClient TPM-Scheduler Setup =========="
echo "Checking for pipx..."
if ! command -v pipx >/dev/null 2>&1; then
  echo "pipx not found. Installing pipx..."
  python3 -m pip install --user pipx
  export PATH="$PATH:$(python3 -m site --user-base)/bin"
  echo "pipx installed."
else
  echo "pipx is already installed."
fi
echo "Ensuring pipx path is set..."
pipx ensurepath
export PATH="$PATH:$(python3 -m site --user-base)/bin"
echo "Installing Python dependencies with pipx..."
pipx install --force --python $(which python3) -r requirements.txt
echo "Making install_tpm.sh executable..."
chmod +x ./install_tpm.sh
echo "Running TPM loader installer..."
./install_tpm.sh
echo "Installing PyInstaller with pipx..."
pipx install --force pyinstaller
echo "Building TPM-Scheduler binary..."
pyinstaller tpm-scheduler.spec
echo "Moving binary to project root..."
mv dist/tpm-scheduler .
echo "Making binary executable..."
chmod +x tpm-scheduler
echo "\n========== Setup Complete =========="
echo "You can now start the app using ./tpm-scheduler"