#!/bin/bash
# Function to install Ansible
install_ansible() {
  echo "Installing Ansible..."
  if ! ansible --version &>/dev/null; then
    if [ -x "$(command -v apt)" ]; then
      sudo apt update && sudo apt upgrade -y
      sudo apt install -y ansible
    elif [ -x "$(command -v dnf)" ]; then
      sudo dnf upgrade --refresh
      sudo dnf install -y ansible
    elif [ -x "$(command -v pacman)" ]; then
      sudo pacman -Syu
      sudo pacman -S --needed ansible
    else
      echo "No supported package manager found. Exiting."
      exit 1
    fi
  else
    echo "Ansible is already installed."
  fi
}
