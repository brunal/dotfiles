#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# terminal emulator daemon
urxvtd -q -f -o

# adds fonts to the path
xset +fp /usr/share/fonts/local
xset fp rehash

# mostly urxvt customisation
xrdb -merge .Xresources

# compositing
xcompmgr &

# lastfm scribbler
# pidof mpdscribble >& /dev/null
# if [ $? -ne 0 ]; then
#    mpdscribble &
# fi

# xflux -l 48.831963 -g 2.353896

# screensaver
xscreensaver -nosplash &

# sets the background
eval $(cat ~/.fehbg)

# caps lock is compose
setxkbmap -option compose:caps

# changes the cursor
xsetroot -cursor_name left_ptr
# and the tray
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 0  --tint block --height 19 & #--monitor 1 &
# and the menu
# cat ~/.menu | dzen2 -p -w 160 -x 1440 -m -l $(wc -l ~/.menu | awk '{print $1-1}') &

pidgin &
xchat &
thunderbird &

#exec ck-launch-session dbus-launch xmonad
exec dbus-launch xmonad
#sxhkd &
#exec dbus-launch bspwm

