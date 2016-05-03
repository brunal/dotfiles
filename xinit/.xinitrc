# executed by lightdm

# terminal emulator daemon
# urxvtd -q -f -o

# adds fonts to the path
# xset +fp /usr/share/fonts/local
# xset fp rehash

# mostly urxvt customisation
# xrdb -merge .Xresources

# merge & manage clipboards
# parcellite &

# pidof xflux >& /dev/null
# if [ $? -ne 0 ]; then
#     xflux -l 48.708918 -g 2.162232
# fi

# screensaver
# xscreensaver -nosplash &

# sets the background
# eval $(cat ~/.fehbg)

# caps lock is compose
setxkbmap -option compose:caps

xcompmgr &
