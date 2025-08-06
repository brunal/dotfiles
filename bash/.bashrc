#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -d "$HOME/.cabal/bin" ]; then
  PATH="$PATH:$HOME/.cabal/bin"
fi

alias fu=fileutil
alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias ll='ls -lah'
alias lspy='ls -B -I \*.pyc'    # for python dev
alias llpy='ll -B -I \*.pyc'    # for python dev
alias treepy='tree -l -I "*.pyc|__init__.py"'
alias ackp='ack --python'

alias trash='trash-put'
alias rm='rm -I'

alias chro='google-chrome'

alias sudo='sudo '              # so I can do sudo <aliased command>

alias gitka='gitk --all &'      # git fuck yeah

alias prettyjson='python -mjson.tool'

alias bell='echo -e \\a'

complete -cf sudo

PS1='[\[\e[0;31m\]\u\[\e[m\] \[\e[0;33m\]\w\[\e[m\]]\[\e[1;30m\]\$\[\e[m\] '

export BROWSER="google-chrome"
export EDITOR="vim"
export DIFF="</dev/tty vimdiff -fRX"

export PYTHONSTARTUP=~/.pythonrc

# history
shopt -s cdspell
shopt -s cmdhist
shopt -s histappend
PROMPT_COMMAND="history -a"
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=1000000

# Random stuff
alias traceroute='echo "Did you mean mtr?" && traceroute'

# set -o vi
bind -m vi-insert "\C-l":clear-screen #^L in vi mode

# completions
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# stderr in red ♥
if [ -f "/usr/lib/libstderred.so" ]; then
    export LD_PRELOAD="/usr/lib/libstderred.so"
fi

# Start x at boot
[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

# automatic screen when connected through ssh
#if [ $SSH_TTY ] && [ ! $WINDOW ]; then
#  SCREENLIST=`screen -ls | grep Attached`
#  if [ $? -eq "0" ]; then
#    echo -e "Screen is already running and attached:\n ${SCREENLIST}"
#  else
#    screen -U -R
#  fi
#fi

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

export PANEL_FIFO=/tmp/panel-fifo


function update-hosts() {
     sudo -s <<< "cat /etc/hosts.d/* > /etc/hosts;"
}

function update-adblock() {
    curl http://someonewhocares.org/hosts/zero/hosts -o /etc/hosts.d/adblock 2> /dev/null
    update-hosts
}

# google
mydiff() { colordiff -u $1 $2 | less -R; }
export -f mydiff
VD() { P4DIFF=vimdiff g4 diff $@; }
export -f VD
export P4DIFF="mydiff"
alias sedall='xargs sed -i'

alias pprint='$(g4 maptofiles //depot/google3/experimental/users/cauet/ppprint.sh)'
alias ppdiff='$(g4 maptofiles //depot/google3/ads/production/optimization/patchpanel/tools/ppdiff.sh)'
alias multi_ppdiff='$(g4 maptofiles //depot/google3/ads/production/optimization/patchpanel/tools/multi_ppdiff.sh)'

alias pastebin=/google/src/head/depot/eng/tools/pastebin
alias g4mv=/google/src/head/depot/google3/experimental/g4mv/g4mv.py
alias gpython=/google/data/ro/projects/sst/gpython
alias iblaze=/google/data/ro/teams/iblaze/iblaze
alias blaze-run.sh=/google/src/head/depot/google3/devtools/blaze/scripts/blaze-run.sh
alias jcfmt=/google/data/ro/teams/job-config/jcfmt
alias datamanager='/google/data/ro/teams/ads-optimization-sre/tools/datamanager --prodspec=ads-optimization-sre'

alias drainctl=/google/data/ro/projects/ads-frontend/drainctl
alias drainctl=/google/data/ro/projects/ads-frontend/drainctl
export PRODSPEC_NAME=ads-optimization-sre
export FRAGMENT_NAME=ads-optimization-sre

alias prodaccess='prodaccess && /google/data/ro/users/di/diamondm/engfortunes/fortune.sh'
export G4PENDINGSTYLE=relativepath

alias latest_iba_samples=/google/src/head/depot/google3/experimental/users/cauet/latest_iba_samples.sh
alias btcfg=/google/data/ro/projects/bigtable/contrib/btcfg/btcfg
alias onborg=/google/data/ro/projects/smartass/onborg
alias readability_tool=/google/data/ro/teams/python-readability/readability_tool
alias edit_bt_schema=/google/src/files/head/depot/google3/experimental/users/cauet/update_bigtable_schema.sh
alias acls=/google/data/ro/projects/ganpati/acls
alias aclcheck=/google/data/ro/projects/ganpati/aclcheck


function csedit() {
  if [ $# -eq 0 ]; then
    echo "No arguments provided"
    return 1
  fi
  $EDITOR $(csearch "$@" | cut -d: -f1 | uniq | cut -d/ -f8-)
  # $EDITOR $(cs "$@" | cut -d: -f1 | uniq | cut -d/ -f8-)
}

export LC_ALL="en_US.UTF-8"

alias bgrep=/google/data/ro/teams/borgtools/bgrep
alias bkill=/google/data/ro/teams/borgtools/bkill
alias btail=/google/data/ro/teams/borgtools/btail
alias annealing=/google/data/ro/teams/annealing/live/annealing

# blaze build $(all_targets)
all_targets() {
  pushd . >/dev/null
  g4d
  g4 whatsout \
    | cut -d/ -f8- \
    | xargs -n1 -I@ sh -c "fullname=\$(blaze query @ 2>/dev/null); blaze query \"attr('srcs', \$fullname, \${fullname//:*/}:*)\" 2>/dev/null" \
    | sort \
    | uniq
  popd >/dev/null
  }

# Continuously build the affected targets.
# Caveat: a new file modified won't be picked up.
iblaze_all() {
  iblaze build $(all_targets)
}


alias pubsub2cfg=/google/data/ro/projects/goops/pubsub2cfg
alias pubsub=/google/data/ro/projects/goops/pubsub

# Helps vim have the right colorscheme when running under gnu screen.
# cf. https://stackoverflow.com/a/6918905
set TERM=xterm-256color
