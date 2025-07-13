#!/bin/bash

echo "Fixing install_tpm permission"
chmod +x ./install_tpm.sh

echo "Executing tpm installation script"
./install_tpm.sh

echo "Installing Python dependencies"
pipx install -r requirements.txt

echo "Executing build"
pyinstaller tpm-scheduler.spec

echo "Moving dist/tpm-scheduler to current directory"
mv dist/tpm-scheduler .

echo "Fixing tpm-scheduler permission"
chmod +x tpm-scheduler

echo "Completed. You can now start the app using ./tpm-scheduler"