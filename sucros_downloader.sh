#!/bin/bash
# Sucros Downloader
# shadowed1

curl -L https://raw.githubusercontent.com/shadowed1/sucros/main/sucros_installer.sh -o /home/chronos/sucros_installer
echo
echo "Run the commands listed below in VT-2 to continue the installer:"
echo "ctrl-alt-refresh to open VT-2 (ctrl-alt-back to exit) - log in as chronos"
echo ""
echo "sudo mv /home/chronos/sucros_installer /usr/local/"
echo "sudo chmod +x /usr/local/sucros_installer"
echo "sudo /usr/local/sucros_installer"
echo
