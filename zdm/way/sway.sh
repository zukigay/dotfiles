#!/bin/bash
export XDG\_SESSION\_TYPE=wayland  
export XDG\_CURRENT\_DESKTOP=sway  
export GBM\_BACKEND=nvidia-drm  
export \_\_GLX\_VENDOR\_LIBRARY\_NAME=nvidia  
export WLR\_NO\_HARDWARE\_CURSORS=1  
export WLR\_DRM\_NO\_ATOMIC=1  
export MOZ_ENABLE_WAYLAND=1
export GDK_BACKEND=x11
export CLUTTER_BACKEND=wayland
export SDL_VIDEODRIVER=wayland
export QT_QPA_PLATFORM=wayland
dbus-run-session sway --unsupported-gpu  
