# Dotfiles
'placeholder for video demo'

## Features
| Software                  | Name                                |
|---|---|
| Window Manager          | [Hyprland](https://hyprland.org/)     |
| Display Manager         | [SDDM](https://github.com/sddm/sddm)  |
| Wallpaper               | [swww](https://github.com/Horus645/swww)  |
| Text Editor             | [NvChad](https://nvchad.com/) & [Neovide](https://neovide.dev/) |
| Font                    | [JetBrainsMono](https://www.jetbrains.com/lp/mono/) & [Iosevka Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Iosevka)   |
| Terminal Emulator       | [foot](https://codeberg.org/dnkl/foot)      |
| Launcher                | [tofi](https://github.com/philj56/tofi)                           |
| Notifications             | [deadd](https://github.com/phuhl/linux_notification_center)      |
| Bar and Widgets         | [waybar](https://github.com/Alexays/Waybar) & [eww](https://github.com/elkowar/eww) |
| Screenlock              | [GTKlock](https://github.com/jovanlanik/gtklock) |
| Authenticator           | [xaskpass](https://github.com/user827/xaskpass) |


## Extras
Software required for widgets to work:

* **playerctl** - control media

* **grep & awk & jq & socat & gjs** - script functionality

* **brightnessctl** - control brightness

* **wlsunset** - blue light filter

* **blueberry** - bluetooth gui

## Install Guide
DISCLAIMER: These dotfiles are held together with duct tape and saftey pins so installing may require troubleshooting outside of the guide

Dependencies
```
wayland hyprland sddm foot neovide waybar-hyprland-git qjackctl deadd-notification-center-bin eww-wayland tofi gtklock-git gtk3 gtk4 playerctl gjs grep awk jq socat swww-git hyprpicker-git pipewire wireplumber pipewire-alsa pipewire-jack pipewire-pulse pipewire-audio wlsunset blueberry brightnessctl 
```
In case swww compile fails, run 
```
rustup default stable
```

Copy repository
```
git clone https://github.com/PoobToo/dotfiles.git
```

Copy configs
```
cp -r dotfiles/dot_local/* .local
cp -r dotfiles/dot_config/* .config
cp dotfiles/extras/wrapped.desktop /usr/share/wayland-sessions/
```
Install NvChad Configs following their [guide](https://nvchad.com/docs/quickstart/install)

Ensure script permissions
```
chmod +x .local/bin/*
chmod +x .config/eww/scripts/*
```
Now just make sure you chose HyprWrapped when logging in on sddm!

## Credits
[@Aylur](https://github.com/Aylur/dotfiles) for most of the bar

[@flick0](https://github.com/flick0/dotfiles/tree/aurora) for workspaces widget

[Crayola](https://shop.crayola.com/color-and-draw/crayons) for their nutritional sustenance 
