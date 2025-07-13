#!/bin/bash

echo "Fixing copy_files permission"
chmod +x ./copy_files.sh

echo "Executing copy script"
./copy_files.sh

echo "Executing build"
pyinstaller tpm-scheduler.spec

echo "Moving dist/tpm-scheduler to current directory"
mv dist/tpm-scheduler .

echo "Fixing tpm-scheduler permission"
chmod +x tpm-scheduler

echo "Completed. You can now start the app using ./tpm-scheduler"