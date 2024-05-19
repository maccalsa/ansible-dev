#!/bin/bash
set -euo pipefail

# Include external scripts
source scripts/install_ansible.sh
source scripts/install_yay.sh
source scripts/install_snapd.sh
source scripts/update_galaxy.sh

# Configuration and dotfiles directories
CONFIG_DIR="$HOME/.config/dotfiles"
DOTFILES_DIR="$HOME/.dotfiles"
SSH_DIR="$HOME/.ssh"
playbook="main.yml"

# Installation functions
install_ansible

# Install yay if the package manager is pacman
[ -x "$(command -v pacman)" ] && install_yay

# Install snapd
if ! [ -x "$(command -v snap)" ]; then
  install_snapd
fi

# Update required collections from Ansible Galaxy
update_galaxy

# Navigate to the dotfiles directory
cd "$DOTFILES_DIR"

# List all the role groups for selection and include system_setup
echo "Please select the role group you'd like to install:"
select role_group in basic_setup development_tools productivity_apps media_tools server_utilities container_tools custom_configs system_setup; do
  case $role_group in
    basic_setup|development_tools|productivity_apps|media_tools|server_utilities|container_tools|custom_configs|system_setup)
      break
      ;;
    *)
      echo "Invalid selection. Please try again."
      ;;
  esac
done

# Run the selected playbook
if [[ -f "$CONFIG_DIR/vault-password.txt" ]]; then
  ansible-playbook --diff --extra-vars "role_group=$role_group" --extra-vars "@$CONFIG_DIR/values.yml" --vault-password-file "$CONFIG_DIR/vault-password.txt" "$DOTFILES_DIR/$playbook" --ask-become-pass "$@"
else
  ansible-playbook --diff --extra-vars "role_group=$role_group" --extra-vars "@$CONFIG_DIR/values.yml" "$DOTFILES_DIR/$playbook" --ask-become-pass "$@"
fi
