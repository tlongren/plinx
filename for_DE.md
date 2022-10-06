# ONLY FOR GNOME

## FLATPAK

com.mattjakeman.ExtensionManager
org.gnome.Extensions

## NORMAL

gnome-tweaks

## dconf

to save settings:

```sh
dconf dump / > dconf-settings.ini
```

```bash
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

        # load settings
        dconf load / < dconf-settings.ini
        ;;
        0)
        ;;
        *)
            echo "Please only use 1 or 0"
            gnome
        ;;
    esac
}
```

# ONLY FOR KDE

```sh
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
            sudo cp -r ${SCRIPT_DIR}/configs/.config/* ~/.config/
            sudo cp ${SCRIPT_DIR}/configs/index.theme /usr/share/icons/default/
            sudo cp ${SCRIPT_DIR}/configs/settings.ini ${HOME}/.config/gtk-3.0/
            pip install konsave
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
```
