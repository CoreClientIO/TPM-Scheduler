#!/bin/bash

echo "Executing copy script"

chmod +x ./copy_files.sh
./copy_files.sh

echo "Executing build"
pyinstaller tpm-scheduler.spec