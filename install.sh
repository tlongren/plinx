#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

logo () {
    echo -ne "

        ███╗   ███╗██╗   ██╗██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
        ████╗ ████║╚██╗ ██╔╝██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
        ██╔████╔██║ ╚████╔╝ ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
        ██║╚██╔╝██║  ╚██╔╝  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
        ██║ ╚═╝ ██║   ██║   ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
        ╚═╝     ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝

        --------------------------------------------------------------------------
                        Welcome to my Post-Install Script
        --------------------------------------------------------------------------
    "
    sleep 2s
}

sys (){
    if [ -x "$(command -v pacman)" ];then
        if (-x "$(command -v yay)");then
            yay -Syu --noconfirm
            bash ${SCRIPT_DIR}/scripts/arch.sh
        else
            # install yay (AUR helper)
            sudo pacman -Syu --noconfirm
            sudo pacman -S --noconfirm --needed git base-devel
            git clone https://aur.archlinux.org/yay-bin.git
            cd yay-bin
            makepkg -si
            # go on with the normal script
            yay -Syu --noconfirm
            bash ${SCRIPT_DIR}/scripts/arch.sh
        fi
        elif [ -x "$(command -v dnf)" ];then
        sudo dnf -y upgrade --refresh
        bash ${SCRIPT_DIR}/scripts/fedora.sh
        elif [ -x "$(command -v apt-get)" ];then
        sudo apt-get -y update && sudo apt-get -y upgrade
        bash ${SCRIPT_DIR}/scripts/debian.sh
    else
        echo 'This Distro is not supported!'
    fi
}

fonts(){
    echo "Checking and installing Meslo and FiraCode Font"
    sleep 2s
    sudo curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    grep "Meslo.zip" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -qi -
    sudo -s unzip Meslo.zip -d /usr/share/fonts
    rm ./Meslo.zip

    sudo -s curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    grep "FiraCode.zip" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -qi -
    sudo unzip FiraCode.zip -d /usr/share/fonts
    # Reloading Font
    fc-cache -vf
    rm ./FiraCode.zip
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

shell(){
    echo -ne "
       Do you want to install a custom Shell?
    "
    echo -ne "
       1) Yes
       0) No
    Choose an option: "
    read -r answer
    case ${answer} in
        1)
            git clone https://github.com/floork/my_shell
            cd my_shell
            bash "install.sh"
            cd $SCRIPT_DIR
            clear
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            shell
        ;;
    esac
}

qemu(){
    echo -ne "
       Do you want to install Qemu?
    "
    echo -ne "
       1) Yes
       0) No
    Choose an option: "
    read -r answer
    case ${answer} in
        1)
            git clone https://github.com/floork/my_qemu
            cd my_qemu
            bash "install.sh"
            cd $SCRIPT_DIR
            clear
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            qemu
        ;;
    esac
}

which_DE(){
    echo -ne "
    Which Desktop Enviorment do you use?
    Do you use:"
    echo -ne "
        1) Hyprland
        2) Gnome
        0) None of these
    Choose an option:  "
    read -r de
    case ${de} in
        1)
            hyprland
        ;;
        2)
            gnome
        ;;
        0)
        ;;
        *)
            echo "Please only the numbers 0 to 2"
            which_DE
        ;;
    esac
}


gnome(){
    if [ -x "$(command -v pacman)" ];then
        if (-x "$(command -v yay)");then
            yay -S -- noconfirm gnome-tweaks
        else
            echo "ERROR: yay is not installed"
        fi
        elif [ -x "$(command -v dnf)" ];then
        sudo dnf -y install gnome-tweaks
        elif [ -x "$(command -v apt-get)" ];then
        sudo apt-get -y install gnome-tweaks
    else
        echo 'This Distro is not supported!'
    fi
    flatpak install -y --noninteractive flathub com.mattjakeman.ExtensionManager
}


hyprland(){
    if [ -x "$(command -v pacman)" ];then
        if (-x "$(command -v yay)");then
            yay -Syu --noconfirm
            bash ${SCRIPT_DIR}/scripts/arch.sh
        else
            yay -S hyprland-bin polkit-gnome ffmpeg neovim viewnior       \
            rofi pavucontrol thunar starship wl-clipboard wf-recorder     \
            swaybg grimblast-git ffmpegthumbnailer tumbler playerctl      \
            noise-suppression-for-voice thunar-archive-plugin kitty       \
            waybar-hyprland wlogout swaylock-effects sddm-git pamixer     \
            nwg-look-bin nordic-theme papirus-icon-theme dunst
            sudo git clone https://github.com/axxapy/Adwaita-dark-gtk2 /usr/share/themes
        fi
        elif [ -x "$(command -v dnf)" ];then
        sudo dnf -y upgrade --refresh
        bash ${SCRIPT_DIR}/scripts/fedora.sh
        elif [ -x "$(command -v apt-get)" ];then
        sudo apt-get -y update && sudo apt-get -y upgrade
        bash ${SCRIPT_DIR}/scripts/debian.sh
    else
        echo 'This Distro is not supported!'
    fi
}

logo2(){
    echo -ne "

            ███╗   ███╗██╗   ██╗██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
            ████╗ ████║╚██╗ ██╔╝██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
            ██╔████╔██║ ╚████╔╝ ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
            ██║╚██╔╝██║  ╚██╔╝  ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
            ██║ ╚═╝ ██║   ██║   ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
            ╚═╝     ╚═╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
            -------------------------------------------------------------------------

                                            Finished!!

            -------------------------------------------------------------------------
    "
}

del(){
    echo -ne "
    Do you want to delete this script?"
    echo -ne "
        1) Yes, delete and reboot
        2) Only delete
        3) Only reboot
        0) No
    Choose an option:  "
    read -r delt
    case ${delt} in
        1)
            sudo rm -r ${SCRIPT_DIR}
            echo "Your System will Reboot in 5 seconds"
            sleep 5s
            sudo reboot -h now
        ;;
        2)
            sudo rm -r ${SCRIPT_DIR}
        ;;
        3)
            echo "Your System will Reboot in 5 seconds"
            sleep 5s
            sudo reboot -h now
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            del
        ;;
    esac
}

export SCRIPT_DIR aur_pkgs debian_pkgs fedora_pkgs flatpaks

logo
sys
which_DE
fonts
cursor
shell
qemu
logo2
del
