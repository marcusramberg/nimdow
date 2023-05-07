#!/usr/bin/env bash

config="${XDG_CONFIG_HOME:-$HOME/.config}/nimdow/config.toml"
if [ ! -e "$config" ]; then
  echo "$config does not exist"
  mkdir -p "${XDG_CONFIG_HOME}/nimdow"
  ln -s "$(pwd)/config.default.toml" "$config"
  printf "Created symlink to %s\n" "$config"
fi

nimble debug || exit 1

# See xserver bug: https://gitlab.freedesktop.org/xorg/xserver/-/issues/1289
unset XDG_SEAT

Xephyr -br -ac -reset -screen 1920x1080 :1 &
sleep 1s
export DISPLAY=:1
xrdb "$HOME/.Xresources" &
./bin/nimdow &

# nm-applet &
~/.fehbg &
