#!/bin/bash

numlock(){
    echo -ne "
        Do you want to use Numlockx?
    "
    echo -ne "
        1) Yes
        0) No
    Choose an option: "
    read -r numlockx
    case ${numlockx} in
        1)
            echo -ne "
        -------------------------------------------------------------------------
                                    Numlockx
        -------------------------------------------------------------------------
            "
            sudo dnf -y install numlockx
            echo "numlockx on" | sudo tee /etc/X11/xinit/xinitrc
            echo "[General]" | sudo tee /etc/sddm.conf
            echo "Numlock=on" | sudo tee -a /etc/sddm.conf
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            numlock
        ;;
    esac
}

installtype() {
    echo -ne "
        Do you want to install all the Programms?
    "
    echo -ne "
        1) Yes
        2) Only flatpaks
        3) Only normal Packages
        0) No
    Choose an option:  "
    read -r install_type
    case ${install_type} in
        1)
            # Get the Repos and Keys
            ##veracrypt
            sudo dnf install \
            wget https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-CentOS-8-x86_64.rpm
            veracrypt-1.25.9-CentOS-8-x86_64.rpm
            ##wine
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/35/winehq.repo
            wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
            chmod +x winetricks
            sudo mv winetricks /usr/local/bin/
            sudo dnf -y winehq
            # install the packages
            while read -r line; do sudo dnf -y install "$line"; done <./../pkgs/pkgs.txt
            # install flatpak
            flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            while read -r line; do flatpak install -y --noninteractive flathub "$line"; done <./../pkgs/flatpaks.txt
            #give flatpak access to themes
            sudo flatpak override --filesystem=~/.themes
        ;;
        2)
            # install flatpak
            flatpak remote-add --if-not-exists --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            while read -r line; do flatpak install -y --noninteractive flathub "$line"; done <./../pkgs/flatpaks.txt
            #give flatpak access to themes
            sudo flatpak override --filesystem=~/.themes
        ;;
        3)
            ## Get the Repos and Keys
            #veracrypt
            sudo dnf -y install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            #wine
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/35/winehq.repo
            wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
            chmod +x winetricks
            sudo mv winetricks /usr/local/bin/
            ## install the packages
            while read -r line; do sudo dnf -y install "$line"; done <./../pkgs/pkgs.txt
        ;;
        0)
        ;;
        *)
            echo "Please only the number 0 to 3"
            installtype
        ;;
    esac
}

numlock
installtype
