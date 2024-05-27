#!/bin/bash

flatpak_ready=FALSE

detect_distro() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        DISTRO_NAME=$NAME
        DISTRO_VERSION=$VERSION
    elif command -v lsb_release &> /dev/null; then
        DISTRO_NAME=$(lsb_release -si)
        DISTRO_VERSION=$(lsb_release -sr)
    elif [ -f /etc/issue ]; then
        DISTRO_NAME=$(cat /etc/issue | awk '{print $1}')
        DISTRO_VERSION=$(cat /etc/issue | awk '{print $2}')
    else
        DISTRO_NAME="Unknown"
        DISTRO_VERSION="Unknown"
    fi
    export DISTRO_NAME
    export DISTRO_VERSION
}

# Install Pacman Packages
install_pacman() {
	echo "Installing Pacman Packages.."
	sudo pacman -Syu --noconfirm
	sudo pacman -S --needed --noconfirm - < pkglist.txtpacman
	echo "Pacman install finished"
	echo "Flatpak"
	flatpak_arch
}

flatpak_arch() {
	echo "Setting up Flatpak & Flathub"
	if ! command -v flatpak &> /dev/null; then
		echo "Flatpak isn't installed, installing"
		sudo pacman -S flatpak --noconfirm
	fi
	flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
	echo "Flatpak and Flathub setup"
	install_flatpak
}

install_flatpak() {
	echo "Installing Flatpak apps.."
	while IFS= read -r app ; do
		flatpak install -y flathub "$app" 
	done < flatpaklist.txt
	echo "Flatpak apps installed"
}

detect_distro

if DISTRO_NAME = "Arch Linux"; then
	echo "Arch detected, Running Arch Install "
	install_pacman

echo "All Packages Installed"
