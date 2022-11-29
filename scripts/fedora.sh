#!/bin/bash

speedUpDNF(){
    echo "# add for speed" | sudo tee -a /etc/dnf/dnf.conf
    echo "fastesmirror=True" | sudo tee -a /etc/dnf/dnf.conf
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
    echo "defaulttypes=True" | sudo tee -a /etc/dnf/dnf.conf
    echo "keepcache=True" | sudo tee -a /etc/dnf/dnf.conf
}

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
            sudo dnf -y install \
            wget https://launchpad.net/veracrypt/trunk/1.25.9/+download/veracrypt-1.25.9-CentOS-8-x86_64.rpm
            ##wine
            sudo dnf -y install dnf-plugins-core
            sudo dnf -y config-manager --add-repo https://dl.winehq.org/wine-builds/fedora/35/winehq.repo
            wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
            chmod +x winetricks
            sudo mv winetricks /usr/local/bin/
            # install VSCode
            sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
            sudo cat <<EOF | sudo tee /etc/yum.repos.d/vscode.repo
[code]
name=Visual Studio Code
baseurl=https://packages.microsoft.com/yumrepos/vscode
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc
EOF
            sudo dnf check-update
            # install rpmfusion
            sudo dnf -y install \
            https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
            sudo dnf -y install \
            https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            # install media codecs
            sudo dnf -y groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
            sudo dnf -y groupupdate sound-and-video
            # set hostname
            sudo hostnamectl set-hostname fedora
            # install the packages
            for item in ${fedora_pkgs[*]}; do sudo dnf -y install ${item}; done
            # install flatpaks
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            for item in ${flatpaks[*]}; do flatpak install -y --noninteractive flathub ${item}; done
            ##give flatpak access to themes
            sudo flatpak override --filesystem=~/.themes
        ;;
        2)
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            for item in ${flatpaks[*]}; do flatpak install -y --noninteractive flathub ${item}; done
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
            for item in ${fedora_pkgs[*]}; do sudo dnf -y install ${item}; done
        ;;
        0)
        ;;
        *)
            echo "Please only the number 0 to 3"
            installtype
        ;;
    esac
}
speedUpDNF
numlock
installtype
