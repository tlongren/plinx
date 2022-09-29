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
            cat ${SCRIPT_DIR}/pkgs/fedora.txt | while read line
            do
                echo "INSTALLING: ${line}"
                sudo dnf -y install ${line}
            done
            ## install flatpaks
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            cat ${SCRIPT_DIR}/pkgs/flatpaks.txt | while read line
            do
                echo "INSTALLING Flatpak's: ${line}"
                flatpak install -y --noninteractive flathub ${line}
            done
            #give flatpak access to themes
            sudo flatpak override --filesystem=~/.themes
        ;;
        2)
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            cat ${SCRIPT_DIR}/pkgs/flatpaks.txt | while read line
            do
                echo "INSTALLING Flatpak's: ${line}"
                flatpak install -y --noninteractive flathub ${line}
            done
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
            cat ${SCRIPT_DIR}/pkgs/fedora.txt | while read line
            do
                echo "INSTALLING: ${line}"
                sudo dnf -y install ${line}
            done
            0)
            ;;
            *)
                echo "Please only use 1 or 0"
                installtype
            ;;
    esac
}

numlock
installtype
