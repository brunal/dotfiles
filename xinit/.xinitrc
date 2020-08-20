# executed by lightdm, for all environments.

echo "actually running .xsessionrc wow wow"
# terminal emulator daemon
urxvtd -q -f -o

# mostly urxvt customisation. Apparently not needed.
xrdb -merge .Xresources

# merge & manage clipboards
parcellite &

# pidof xflux >& /dev/null
# if [ $? -ne 0 ]; then
#     xflux -l 48.708918 -g 2.162232
# fi

# screensaver
xscreensaver -nosplash &

# caps lock is compose
setxkbmap -option compose:caps

# uncomment once I get my screens back
# xrandr --output DP-4 --rotate left --output DP-5 --rotate right --right-of DP-4

# sets the background
~/.fehbg &

xcompmgr &

xchat &
