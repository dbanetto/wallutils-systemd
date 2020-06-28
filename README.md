# wallutil-*.service

A collection of systemd service files focused on changing wallpapers.

These are designed to be run as systemd user services & timers.

## Dependencies

The following dependencies are required

 * systemd (default on systemd-based distros)
 * envsubst (default on most distros)
 * [wallutils](https://github.com/xyproto/wallutils)

## Configuration

```bash
## Config
WALLPAPER_PATH="${HOME}/Pictures/Wallpapers" # <== path to wallpapers
# When 
# see system.timer(5) for timing syntax
STARTUP_DELAY="1m" # <== delay between starting up & first run
CHANGE_EVERY="1h" # <== delay until next run
```

## What is going on?!

The magic sauce here is using `envsubst` as a basic templating engine.

It replaces bash-like variables `${VAR}` with the value
of the corresponding environment variable.

To ensure that other troublesome variables do not show up it is executed with a
clean `env` that has expected variables passed in to it.

This is all a bit of a overkill for this context but a fun way to explore `envsubst` .As far as I can tell, at
least on Arch Linux, is installed by default so a nice low dependency
templating "engine".
