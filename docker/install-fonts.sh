#!/usr/bin/env bash
set -euo pipefail
DEST_DIR=/usr/local/share/fonts

wget --version > /dev/null

if [[ $? -ne 0 ]]; then
        echo "wget not available , installing"
        sudo apt update && sudo apt install wget -y
fi

unzip >> /dev/null

if [[ $? -ne 0 ]]; then
        echo "unzip not available , installing"
        sudo apt update && sudo apt install unzip -y
fi


wget -O fonts.zip "https://fonts.google.com/download?family=Roboto|Noto%20Sans|Open%20Sans|Roboto%20Condensed|Source%20Sans%20Pro|Raleway|Merriweather|Roboto%20Slab|PT%20Sans|Open%20Sans%20Condensed|Droid%20Sans|Droid%20Serif|Fira%20Sans|Fira%20Sans%20Condensed|Fira%20Sans%20Extra%20Condensed|Fira%20Mono"
mkdir /tmp/nej-fonts
sudo unzip fonts.zip -d /tmp/nej-fonts
rm fonts.zip

wget -O firacode.zip "https://github.com/tonsky/FiraCode/releases/download/5.2/Fira_Code_v5.2.zip"
sudo unzip firacode.zip -d /tmp/nej-fonts
rm firacode.zip

wget -O firacode-symbols.zip "https://github.com/tonsky/FiraCode/files/412440/FiraCode-Regular-Symbol.zip"

sudo unzip firacode-symbols.zip -d /tmp/nej-fonts

sudo find /tmp/nej-fonts -name \*.ttf -o -name \*.otf -exec mv \{\}  ${DEST_DIR} \;



sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeui.ttf?raw=true -O "$DEST_DIR"/segoeui.ttf  # regular
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuib.ttf?raw=true -O "$DEST_DIR"/segoeuib.ttf  # bold
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuii.ttf?raw=true -O "$DEST_DIR"/segoeuii.ttf  # italic
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuiz.ttf?raw=true -O "$DEST_DIR"/segoeuiz.ttf  # bold italic
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuil.ttf?raw=true -O "$DEST_DIR"/segoeuil.ttf  # light
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/seguili.ttf?raw=true -O "$DEST_DIR"/seguili.ttf  # light italic
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuisl.ttf?raw=true -O "$DEST_DIR"/segoeuisl.ttf  # semilight
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisli.ttf?raw=true -O "$DEST_DIR"/seguisli.ttf  # semilight italic
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisb.ttf?raw=true -O "$DEST_DIR"/seguisb.ttf  # semibold
sudo wget  https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisbi.ttf?raw=true -O "$DEST_DIR"/seguisbi.ttf  # semibold italic

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
