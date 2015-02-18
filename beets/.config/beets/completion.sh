# This file is part of beets.
# Copyright (c) 2014, Thomas Scholtes.
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.



# Completion for the `beet` command
# =================================
#
# Load this script to complete beets subcommands, options, and
# queries.
#
# If a beets command is found on the command line it completes filenames and
# the subcommand's options. Otherwise it will complete global options and
# subcommands. If the previous option on the command line expects an argument,
# it also completes filenames or directories.  Options are only
# completed if '-' has already been typed on the command line.
#
# Note that completion of plugin commands only works for those plugins
# that were enabled when running `beet completion`. It does not check
# plugins dynamically
#
# Currently, only Bash 3.2 and newer is supported and the
# `bash-completion` package is requied.
#
# TODO
# ----
#
# * There are some issues with arguments that are quoted on the command line.
#
# * Complete arguments for the `--format` option by expanding field variables.
#
#     beet ls -f "$tit[TAB]
#     beet ls -f "$title
#
# * Support long options with `=`, e.g. `--config=file`. Debian's bash
#   completion package can handle this.
#


# Determines the beets subcommand and dispatches the completion
# accordingly.
_beet_dispatch() {
  local cur prev cmd=

  COMPREPLY=()
  _get_comp_words_by_ref -n : cur prev

  # Look for the beets subcommand
  local arg
  for (( i=1; i < COMP_CWORD; i++ )); do
      arg="${COMP_WORDS[i]}"
      if _list_include_item "${opts___global}" $arg; then
        ((i++))
      elif [[ "$arg" != -* ]]; then
        cmd="$arg"
        break
      fi
  done

  # Replace command shortcuts
  if [[ -n $cmd ]] && _list_include_item "$aliases" "$cmd"; then
    eval "cmd=\$alias__$cmd"
  fi

  case $cmd in
    help)
      COMPREPLY+=( $(compgen -W "$commands" -- $cur) )
      ;;
    list|remove|move|update|write|stats)
      _beet_complete_query
      ;;
    "")
      _beet_complete_global
      ;;
    *)
      _beet_complete
      ;;
  esac
}


# Adds option and file completion to COMPREPLY for the subcommand $cmd
_beet_complete() {
  if [[ $cur == -* ]]; then
    local opts flags completions
    eval "opts=\$opts__$cmd"
    eval "flags=\$flags__$cmd"
    completions="${flags___common} ${opts} ${flags}"
    COMPREPLY+=( $(compgen -W "$completions"  -- $cur) )
  else
    _filedir
  fi
}


# Add global options and subcommands to the completion
_beet_complete_global() {
  case $prev in
    -h|--help)
      # Complete commands
      COMPREPLY+=( $(compgen -W "$commands" -- $cur) )
      return
      ;;
    -l|--library|-c|--config)
      # Filename completion
      _filedir
      return
      ;;
    -d|--directory)
      # Directory completion
      _filedir -d
      return
      ;;
  esac

  if [[ $cur == -* ]]; then
    local completions="$opts___global $flags___global"
    COMPREPLY+=( $(compgen -W "$completions" -- $cur) )
  elif [[ -n $cur ]] && _list_include_item "$aliases" "$cur"; then
    local cmd
    eval "cmd=\$alias__$cur"
    COMPREPLY+=( "$cmd" )
  else
    COMPREPLY+=( $(compgen -W "$commands" -- $cur) )
  fi
}

_beet_complete_query() {
  local opts
  eval "opts=\$opts__$cmd"

  if [[ $cur == -* ]] || _list_include_item "$opts" "$prev"; then
    _beet_complete
  elif [[ $cur != \'* && $cur != \"* &&
          $cur != *:* ]]; then
    # Do not complete quoted queries or those who already have a field
    # set.
    compopt -o nospace
    COMPREPLY+=( $(compgen -S : -W "$fields" -- $cur) )
    return 0
  fi
}

# Returns true if the space separated list $1 includes $2
_list_include_item() {
  [[ " $1 " == *[[:space:]]$2[[:space:]]* ]]
}

# This is where beets dynamically adds the _beet function. This
# function sets the variables $flags, $opts, $commands, and $aliases.
complete -o filenames -F _beet beet
_beet() {
  local commands='fields help import list update remove stats version modify move write config completion splupdate mpdstats lyrics fetchart web duplicates thumbnails info submit fingerprint lastgenre'

  local aliases='upd up imp mv im ls dup rm mod'
  local alias__upd=update
  local alias__up=update
  local alias__imp=import
  local alias__mv=move
  local alias__im=import
  local alias__ls=list
  local alias__dup=duplicates
  local alias__rm=remove
  local alias__mod=modify

  fields='lyrics album_id albumstatus disctitle year month channels genre original_day disc mb_trackid composer mtime albumdisambig samplerate albumartist_sort id album mb_artistid bitdepth disctotal title media artist_sort mb_albumid comments acoustid_fingerprint rg_album_gain script mb_releasegroupid acoustid_id rg_album_peak albumartist_credit catalognum added original_month format track comp artpath encoder initial_key rg_track_gain path bitrate day original_year tracktotal language artist asin mb_albumartistid bpm label length albumartist albumtype artist_credit country rg_track_peak grouping'
  local opts__mpdstats='--host --port --password'
  local flags__lyrics='-p --print -f --force'
  local flags__duplicates='-a --album -c --count -d --delete -F --full -p --path'
  local opts__duplicates='-f --format -C --checksum -k --keys -m --move -o --copy -t --tag'
  local flags__move='-c --copy -a --album'
  local opts__move='-d --dest'
  local flags___common='-h --help'
  local flags___global='-v --verbose'
  local opts___global='-l --library -c --config -d --directory -h --help'
  local flags__web='-d --debug'
  local flags__stats='-e --exact'
  local flags__write='-p --pretend -f --force'
  local flags__lastgenre='-f --force'
  local opts__lastgenre='-s --source'
  local flags__import='-c --copy -C --nocopy -w --write -W --nowrite -a --autotag -A --noautotag -p --resume -P --noresume -q --quiet -s --singletons -t --timid -L --library -i --incremental -I --noincremental --flat -g --group-albums --pretend'
  local opts__import='-l --log'
  local flags__config='-p --paths -e --edit -d --defaults'
  local flags__fetchart='-f --force'
  local flags__modify='-M --nomove -w --write -W --nowrite -a --album -y --yes'
  local opts__modify='-f --format'
  local flags__update='-a --album -M --nomove -p --pretend'
  local opts__update='-f --format'
  local flags__info='-l --library -s --summarize'
  local opts__info='-i --include-keys'
  local flags__thumbnails='-f --force --dolphin'
  local flags__list='-a --album -p --path'
  local opts__list='-f --format'
  local flags__remove='-d --delete -a --album'
  _beet_dispatch
}