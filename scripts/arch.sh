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
            yay -S  --noconfirm --needed numlockx
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

cursor(){
        echo -ne "
        Do you want to use the future-black-cursor?
        "
        echo -ne "
        1) Yes
        0) No
        Choose an option: "
        read -r answer
        case ${answer} in
        1)
        sudo cp -r ${SCRIPT_DIR}/configs/Future-black-cursors /usr/share/icons
        echo '[Icon Theme]' | sudo tee /usr/share/icons/default/index.theme
        echo 'Inherits=Future-black Cursors' | sudo tee -a /usr/share/icons/default/index.theme
        ;;
        0)
        ;;
        *)
        echo "Please only use 1 or 0"
        cursor
        ;;
        esac
    }

installtype() {
        echo -ne "
        Do you want to install all the Programms?
        "
        echo -ne "
        1) Yes
        0) No
        Choose an option:  "
        read -r install_type
        case ${install_type} in
        1)
            cat ${SCRIPT_DIR}/pkgs/pacman-pkgs.txt | while read line
            do
                echo "INSTALLING: ${line}"
                sudo pacman -S --noconfirm --needed ${line}
            done
         cat ${SCRIPT_DIR}/pkgs/aur-pkgs.txt | while read line
            do
                echo "INSTALLING Yay-Packages: ${line}"
                yay -S --noconfirm --needed ${line}
            done
         flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            cat ${SCRIPT_DIR}/pkgs/flatpaks.txt | while read line
            do
                echo "INSTALLING Flatpak's: ${line}"
               flatpak install -y --noninteractive flathub ${line}
            done
            #give flatpak access to themes
            sudo flatpak override --filesystem=~/.themes
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            installtype
        ;;
        esac
    }

numlock
cursor
installtype
