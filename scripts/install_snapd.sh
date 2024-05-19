#!/bin/bash

install_snapd() {
  # Determine OS distribution
  source /etc/os-release

  case $ID in
    arch)
      echo "Installing snapd on Arch Linux..."
      if ! [ -x "$(command -v snap)" ]; then
        if [ -x "$(command -v git)" ] && [ -x "$(command -v makepkg)" ]; then
          git clone https://aur.archlinux.org/snapd.git
          pushd snapd
          makepkg -si --noconfirm
          popd
          rm -rf snapd
          
          echo "Enabling snapd services..."
          sudo systemctl enable --now snapd.socket
          sudo systemctl enable --now snapd.apparmor.service
          
          echo "Creating symbolic link for snap..."
          sudo ln -s /var/lib/snapd/snap /snap
        else
          echo "Required tools (git, makepkg) are not installed."
          exit 1
        fi
      else
        echo "snapd is already installed."
      fi
      ;;
    fedora)
      echo "Installing snapd on Fedora..."
      sudo dnf install snapd -y
      sudo ln -s /var/lib/snapd/snap /snap
      
      echo "Installing snap-store..."
      sudo snap install snap-store
      ;;
    debian|ubuntu)
      echo "Installing snapd on Debian/Ubuntu..."
      sudo apt update
      sudo apt install snapd -y
      sudo ln -s /var/lib/snapd/snap /snap
      
      echo "Installing snap-store..."
      sudo snap install snap-store
      ;;
    *)
      echo "Unsupported distribution: $ID"
      exit 1
      ;;
  esac

  echo "Please logout or restart your machine and then rerun this script to complete the setup."
}