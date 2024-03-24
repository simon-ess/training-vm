#!/bin/sh
# bootstrap.sh

# Simple bootstrap script for Rocky 9
# - installs prerequisites: git, ansible
# - clones training-vm repo into ./bootstrap

# $1 = repo (default: GitHub)

BOOTSTRAP_DIR="bootstrap"
BOOTSTRAP_REPO=${1:-"https://github.com/epics-training/training-vm"}

# Install prerequisites: Git, Ansible
if ! command -v git >/dev/null; then
    packages="git "
fi
if ! command -v ansible >/dev/null; then
    packages="${packages}ansible"
fi
if [ "${packages}" ]; then    
    echo "Installing prerequisites: ${packages}..."
    sudo dnf update
    sudo dnf install -y ${packages}
else
    echo "All prerequisites are installed."
fi

# Clone the training-vm bootstrap
if [ ! -e "${BOOTSTRAP_DIR}" ]; then
    echo "Cloning training-vm configuration into ./${BOOTSTRAP_DIR}..."
    git clone ${BOOTSTRAP_REPO} ${BOOTSTRAP_DIR}
else
    echo "Using existing training-vm configuration in ./${BOOTSTRAP_DIR}."
fi
