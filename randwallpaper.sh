#!bin/sh
DIR='/home/leo/Wallpapers/'
BG=$(find "$DIR" -type f \( -iname "*.jpg" -o -iname "*.webp" -o -iname "*.gif" \) | shuf -n 1)

function loadwp() {
  swww img $BG -t wipe --transition-wave 0.0,0.0,1.0,1.0 --transition-duration .8 --transition-step 255 --transition-fps 60
}

#load wallpaper daemon if not loaded
if ! swww query; then
  swww-daemon
fi

#load wallpaper as function defined above
loadwp

#generate colorscheme
wal -i $BG -n

#append colorsheme to wofi css
printf '%s\n%s\n' "$(cat ~/.cache/wal/colors-waybar.css)" "$(cat ~/.config/wofi/template.css)" >~/.config/wofi/style.css

#reload waybar
killall waybar
sleep 0.6
waybar
