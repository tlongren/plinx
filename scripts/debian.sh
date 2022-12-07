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
        sudo apt-get -y install numlockx
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
        # install Discord
        sudo apt -y install gdebi-core wget
        wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
        sudo gdebi ~/discord.deb
        sudo rm ~/discord.deb
        # get veracrypt Repo
        sudo add-apt-repository ppa:unit193/encryption
        # install wine
        sudo wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
        sudo wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
        sudo apt update -y
        sudo apt install --install-recommends winehq-stable
        # install normal packages
        while read -r line; do sudo apt-get -y install "$line"; done <./../pkgs/apt.txt
        # install flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        while read -r line; do flatpak install -y --noninteractive flathub "$line"; done <./../pkgs/flatpaks.txt
        #give flatpak access to themes
        sudo flatpak override --filesystem=~/.themes
        ;;
    2)
        # install flatpak
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
        while read -r line; do flatpak install -y --noninteractive flathub "$line"; done <./../pkgs/flatpaks.txt
        #give flatpak access to themes
        sudo flatpak override --filesystem=~/.themes
        ;;
    3)
        # install Discord
        sudo apt -y install gdebi-core wget
        wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
        sudo gdebi ~/discord.deb
        sudo rm ~/discord.deb
        # get veracrypt Repo
        sudo add-apt-repository ppa:unit193/encryption
        # install wine
        sudo wget -nc -O /usr/share/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
        sudo wget -nc -P /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/focal/winehq-focal.sources
        sudo apt update -y
        sudo apt install --install-recommends winehq-stable
        # install normal packages
        while read -r line; do sudo apt-get -y install "$line"; done <./../pkgs/apt.txt
        ;;
    0) ;;

    *)
        echo "Please only the number 0 to 3"
        installtype
        ;;
    esac
}

numlock
installtype
