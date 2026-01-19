#!/usr/bin/env bash
set -oue pipefail

# 1. Create the 'wants' directory for the niri service
SERVICE_PATH="/usr/lib/systemd/user/plasma-polkit-agent.service"
DROPIN_DIR="${SERVICE_PATH}.d"
WANTS_DIR="/usr/lib/systemd/user/niri.service.wants"
mkdir -p "$WANTS_DIR"

mkdir -p "$DROPIN_DIR"
cat <<EOF > "$DROPIN_DIR/niri-overrides.conf"
[Unit]
After=graphical-session.target
EOF

# 2. Symlink the services.
# This is the equivalent of 'systemctl --user add-wants niri.service ...'
# We link both the ones we created and the ones provided by RPMs (Waybar/Mako)

# From RPMs:
ln -sf /usr/lib/systemd/user/waybar.service "$WANTS_DIR/waybar.service"
ln -sf /usr/lib/systemd/user/mako.service "$WANTS_DIR/mako.service"

# From our custom 'files' module:
ln -sf /usr/lib/systemd/user/swaybg.service "$WANTS_DIR/swaybg.service"
ln -sf /usr/lib/systemd/user/swayidle.service "$WANTS_DIR/swayidle.service"

# Plasma-polkit
ln -sf "$SERVICE_PATH" "$WANTS_DIR/plasma-polkit-agent.service"

# Optional: Add xwayland-satellite if you want X11 support to start with Niri
if [ -f /usr/lib/systemd/user/xwayland-satellite.service ]; then
    ln -sf /usr/lib/systemd/user/xwayland-satellite.service "$WANTS_DIR/xwayland-satellite.service"
fi
