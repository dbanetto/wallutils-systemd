#!/bin/bash

set -e

## Config
# Path to the wallpapers
WALLPAPER_PATH="${HOME}/Pictures/Wallpapers"
# Options for when the wallpaper will get changed
# see system.timer(5) for timing syntax
STARTUP_DELAY="1m"
CHANGE_EVERY="1h"

# config validation
[ ! -d "${WALLPAPER_PATH}" ] && echo "${WALLPAPER_PATH} directory does not exist" && exit 1
systemd-analyze timespan "${STARTUP_DELAY}" > /dev/null
systemd-analyze timespan "${CHANGE_EVERY}" > /dev/null

INSTALL_DIR="${HOME}/.config/systemd/user"
mkdir -p ~/.config/systemd/user

env -i \
    WALLPAPER_PATH="${WALLPAPER_PATH}" \
    envsubst < ./wallutils-random.service > "${INSTALL_DIR}/wallutils-random.service"

env -i \
    WALLPAPER_PATH="${WALLPAPER_PATH}" \
    CHANGE_EVERY="${CHANGE_EVERY}" \
    STARTUP_DELAY="${STARTUP_DELAY}" \
    envsubst < ./wallutils-random.timer > "${INSTALL_DIR}/wallutils-random.timer"

# Check ourselves
# Note: the `--user` part is important to validate the units against user services/targets
systemd-analyze --user verify ${INSTALL_DIR}/wallutils-*

# load units & turns it on
systemctl daemon-reload --user
systemctl enable --user wallutils-random.timer
systemctl start --user wallutils-random.timer
