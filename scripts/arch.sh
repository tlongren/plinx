#!/bin/bash

numlock() {
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
        yay -S --noconfirm --needed numlockx
        echo "numlockx on" | sudo tee /etc/X11/xinit/xinitrc
        echo "[General]" | sudo tee /etc/sddm.conf
        echo "Numlock=on" | sudo tee -a /etc/sddm.conf
        ;;
    0) ;;

    *)
        echo "Please only use 1 or 0"
        numlock
        ;;
    esac
}

installtype() {
    echo -ne "
        Do you want to install all the programs?
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
        # install yay pkgs
        while read -r line; do yay -S --noconfirm --needed "$line"; done <./../pkgs/aur.txt
        # install flatpaks
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        while read -r line; do flatpak install -y --noninteractive flathub "$line"; done <./../pkgs/flatpaks.txt
        #give flatpak access to themes
        sudo flatpak override --filesystem=~/.themes
        ;;
    2)
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        while read -r line; do flatpak install -y --noninteractive flathub "$line"; done <./../pkgs/flatpaks.txt
        #give flatpak access to themes
        sudo flatpak override --filesystem=~/.themes
        ;;
    3)
        # cat ${SCRIPT_DIR}/pkgs/aur-pkgs.txt | while read line
        while read -r line; do yay -S --noconfirm --needed "$line"; done <./../pkgs/aur.txt
        ;;
    0) ;;

    *)
        echo "Please only the number 0 to 3"
        installtype
        ;;
    esac
}
