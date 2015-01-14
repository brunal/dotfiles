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
pidof mpdscribble >& /dev/null
if [ $? -ne 0 ]; then
    mpdscribble &
fi

# merge & manage clipboards
parcellite &

pidof xflux >& /dev/null
if [ $? -ne 0 ]; then
    xflux -l 48.708918 -g 2.162232
fi

# screensaver
xscreensaver -nosplash &

# sets the background
eval $(cat ~/.fehbg)

# caps lock is compose
setxkbmap -option compose:caps

# adds cabal's binaries to the path
if [[ :$PATH: != :*$HOME/.cabal/bin:* ]]; then
        export PATH=$PATH:~/.cabal/bin
fi;

launch_xmonad() {
  # changes the cursor
  xsetroot -cursor_name left_ptr
  # and the tray
  trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 0  --tint block --height 19 & #--monitor 1 &
  # and the menu
  # cat ~/.menu | dzen2 -p -w 160 -x 1440 -m -l $(wc -l ~/.menu | awk '{print $1-1}') &

  xchat &

  exec dbus-launch xmonad
  #sxhkd &
  #exec dbus-launch bspwm
}

launch_gnome() {
    exec gnome-session
}

launch_xfce4() {
    # compositing
    xcompmgr &

    startxfce4 &
    exec xmonad --replace
}

DEFAULT_SESSION=gnome-session
# FIXME this is shit
CHOICE=xmonad

#case $1 in
case $CHOICE in
xmonad)
    launch_xmonad
    ;;
gnome)
    launch_gnome
    ;;
xfce4)
    launch_xfce4
    ;;
*)
    # FIXME
    exec $DEFAULT_SESSION
    ;;
esac
