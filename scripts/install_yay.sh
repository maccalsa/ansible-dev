#!/bin/bash

# Check and install yay for Arch Linux
install_yay() {
  echo "Checking for yay package manager..."
  if [ -x "$(command -v pacman)" ] && ! [ -x "$(command -v yay)" ]; then
    sudo pacman -S --needed git go base-devel
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -si
    popd
    rm -rf yay
  fi
}