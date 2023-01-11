#!/usr/bin/env bash
set -euo pipefail
DEST_DIR=/usr/local/share/fonts

wget --version >/dev/null

if [[ $? -ne 0 ]]; then
        echo "wget not available , installing"
        sudo apt update && sudo apt install wget -y
fi

unzip >>/dev/null

if [[ $? -ne 0 ]]; then
        echo "unzip not available , installing"
        sudo apt update && sudo apt install unzip -y
fi

mkdir /tmp/nej-fonts

for f in Roboto "Noto%20Sans" "Open%20Sans" "Source%20Sans%20Pro" "Source%20Code%20Pro" "Roboto%20Mono" "Roboto%20Condensed" "Roboto" "Fira%20Sans" "Fira%20Sans%20Condensed" "Fira%20Mono" "Fira%20Code"; do
        wget -O fonts.zip "https://fonts.google.com/download?family=${f}"
        # remove info files in root folders
        sudo find /tmp/nej-fonts -maxdepth 1 -type f -delete
        sudo unzip fonts.zip -d /tmp/nej-fonts
        rm fonts.zip
done

# https://github.com/tonsky/FiraCode/
wget -O firacode.zip "https://github.com/tonsky/FiraCode/releases/download/6.2/Fira_Code_v6.2.zip"
sudo find /tmp/nej-fonts -maxdepth 1 -type f -delete
sudo unzip firacode.zip -d /tmp/nej-fonts
rm firacode.zip

sudo find /tmp/nej-fonts -name \*.ttf -o -name \*.otf -exec mv \{\} ${DEST_DIR} \;

# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeui.ttf?raw=true -O "$DEST_DIR"/segoeui.ttf     # regular
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuib.ttf?raw=true -O "$DEST_DIR"/segoeuib.ttf   # bold
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuii.ttf?raw=true -O "$DEST_DIR"/segoeuii.ttf   # italic
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuiz.ttf?raw=true -O "$DEST_DIR"/segoeuiz.ttf   # bold italic
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuil.ttf?raw=true -O "$DEST_DIR"/segoeuil.ttf   # light
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/seguili.ttf?raw=true -O "$DEST_DIR"/seguili.ttf     # light italic
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuisl.ttf?raw=true -O "$DEST_DIR"/segoeuisl.ttf # semilight
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisli.ttf?raw=true -O "$DEST_DIR"/seguisli.ttf   # semilight italic
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisb.ttf?raw=true -O "$DEST_DIR"/seguisb.ttf     # semibold
# sudo wget https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisbi.ttf?raw=true -O "$DEST_DIR"/seguisbi.ttf   # semibold italic

if [[ $? -ne 0 ]]; then
        echo "Downloading failed , exiting"
        exit 1
fi

echo "purging fonts cache "
fc-cache -v -f

echo "Done"
sleep 2
echo "Setting default fonts "

gsettings set org.gnome.desktop.interface document-font-name 'Fira Sans Regular 11'
gsettings set org.gnome.desktop.interface font-name 'Fira Sans Regular 10'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code Regular 12'
gsettings set org.gnome.desktop.interface text-scaling-factor '1'

echo "Done"
