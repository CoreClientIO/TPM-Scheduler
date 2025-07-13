#!/bin/bash

wget https://github.com/IcyHenryT/TPM-Loader/releases/latest/download/TPM-loader-linux && chmod +x TPM-loader-linux

echo "Please configure TPM now."

./TPM-loader-linux
