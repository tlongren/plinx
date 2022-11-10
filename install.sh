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
    sleep 5s
    FONT_INSTALLED=$(fc-list | grep -i "Meslo");
    if ! [ "$FONT_INSTALLED" ]; then
        sudo curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
        |   grep "Meslo.zip" \
        |   cut -d : -f 2,3 \
        |   tr -d \" \
        |   wget -qi -
        sudo -s unzip Meslo.zip -d /usr/share/fonts
        # Reloading Font
        fc-cache -vf
        rm ./Meslo.zip
    else
        :
    fi
    FONT_INSTALLED=$(fc-list | grep -i "Fira Code");
    if ! [ "$FONT_INSTALLED" ]; then
        sudo -s curl -s https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest \
        |   grep "FiraCode.zip" \
        |   cut -d : -f 2,3 \
        |   tr -d \" \
        |   wget -qi -
        sudo unzip FiraCode.zip -d /usr/share/fonts
        # Reloading Font
        fc-cache -vf
        rm ./FiraCode.zip
    else
        :
    fi
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
            curl -sS https://starship.rs/install.sh | sh
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
        1) Gnome
        2) Kde
        0) None of these
    Choose an option:  "
    read -r de
    case ${de} in
        1)
            gnome
        ;;
        2)
            konsa
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
    echo -ne "
    Do you want to install my Gnome Configs?"
    echo -ne "
        1) ALL
        0) Do nothing
    Choose an option:  "
    read -r kon
    case ${kon} in
        1)
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
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            gnome
        ;;
    esac
}

konsa(){
    echo -ne "
    Do you want to install my KDE Configs?"
    echo -ne "
        1) ALL
        0) Do nothing
    Choose an option:  "
    read -r kon
    case ${kon} in
        1)
            if [ -x "$(command -v pacman)" ];then
                if (-x "$(command -v yay)");then
                    yay -S -- noconfirm python-pip latte-dock
                else
                    echo "ERROR: yay is not installed"
                fi
                elif [ -x "$(command -v dnf)" ];then
                sudo dnf -y install python-pip latte-dock
                elif [ -x "$(command -v apt-get)" ];then
                sudo apt-get -y install python-pip latte-dock
            else
                echo 'This Distro is not supported!'
            fi
            sudo cp -r ${SCRIPT_DIR}/configs/.config/* ~/.config/
            sudo cp ${SCRIPT_DIR}/configs/index.theme /usr/share/icons/default/
            sudo cp ${SCRIPT_DIR}/configs/settings.ini ${HOME}/.config/gtk-3.0/
            python -m pip install konsave
            konsave -i ${SCRIPT_DIR}/configs/kde.knsv
            sleep 1
            konsave -a kde
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            konsa
        ;;
    esac
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

export SCRIPT_DIR

logo
sys
which_DE
fonts
cursor
shell
qemu
logo2
del
