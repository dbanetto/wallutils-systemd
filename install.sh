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
    envsubst < ./wallutil-random.service > "${INSTALL_DIR}/wallutil-random.service"

env -i \
    WALLPAPER_PATH="${WALLPAPER_PATH}" \
    CHANGE_EVERY="${CHANGE_EVERY}" \
    STARTUP_DELAY="${STARTUP_DELAY}" \
    envsubst < ./wallutil-random.timer > "${INSTALL_DIR}/wallutil-random.timer"

# Check ourselves
# Note: the `--user` part is important to validate the units against user services/targets
systemd-analyze --user verify ${INSTALL_DIR}/wallutil-*

# load units & turns it on
systemctl daemon-reload --user
systemctl enable --user wallutil-random.timer
systemctl start --user wallutil-random.timer
