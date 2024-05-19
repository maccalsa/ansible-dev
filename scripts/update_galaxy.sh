#!/bin/bash

# Install required collections from Ansible Galaxy
update_galaxy() {
  echo "Updating required collections from Ansible Galaxy..."
  ansible-galaxy install -r requirements.yml
}