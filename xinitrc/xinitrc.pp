#!/bin/bash

if [ "x$BASH_VERSION" == x ]; then
   exec /usr/bin/env bash $0
fi

#> define LOG_FILE "/dev/null"
#> define LOG_FILE "/tmp/xinitrc.$USER.$$.WINDOW_MANAGER.log"

run() {
   "$@" &
}

has() {
   which "$1"
}

has_run() {
   has "$1" && run "$@"
   return 0
}

{
   date; # date for for log file

   # === Dirs that we want to keep in /tmp ================
   USER_TMP_DIR="/tmp/home-temp-${USER}";

   #TODO? mozilla stuff?
   #.cache \

   for d in \
      .adobe \
      .macromedia \
      ; \
   do
      echo "Linking $d to temp";
      rm -rf ~/"$d"
      mkdir -p "$USER_TMP_DIR/$d"   &&
      chmod 0755 "$USER_TMP_DIR/$d" &&
      ln -s "$USER_TMP_DIR/$d" ~/"$d";
   done
   # ======================================================

   # === Music Player Daemon ==============================
   #has_run mpd;

   # === Our notification daemon ===
   has_run dunst;

   # === Remap Mousebuttons ===
   has_run imwheel;

   # === Disable touchpad while typing ===
   #has_run syndaemon -i 0.5 -t -K -R

   # === Open browser =====================================
   #> ifndef STARTPAGE
   #>    define STARTPAGE blog.fefe.de
   #> endif
   has_run bnox      "STARTPAGE" ||
   has_run inox      "STARTPAGE" ||
   has_run chromium  "STARTPAGE" ||
   has_run palemoon  "STARTPAGE" ||
   has_run firefox   "STARTPAGE" ||
   has_run dillo     "STARTPAGE"

   # === Host based applications ==========================
   #> if "HOST" eq "pizwo"
      # has_run synergys
   #> elif "HOST" eq "samsung"
      # has_run synergyc 10.0.0.10
   #> endif

   # === Select terminal emulator =========================
   if has uxterm; then
      terminal_cmd='uxterm -maximized -e'
   elif has xterm; then
      terminal_cmd='xterm -maximized -e'
   elif has evilvte; then
      terminal_cmd='evilvte -f -e'
   elif has terminator; then
      terminal_cmd='terminator -f -b -x'
   fi
   # ======================================================

   # === Select terminal init =============================
   if has tmux; then
      tmux has-session -t 'main' || tmux new-session -d -s 'main'
      tmux has-session -t 'bg'   || tmux new-session -d -s 'bg'

      #has ncmpcpp && tmux new-window -t 'main:' 'ncmpcpp'
      #{ has finch   && tmux new-window -t 'main:' 'finch';   } ||
      #{ has mcabber && tmux new-window -t 'main:' 'mcabber'; } 

      terminal_init='tmux -2 attach -t main'
   elif has zsh; then
      terminal_init='zsh';
   else
      terminal_init='bash';
   fi
   # ======================================================

   # === Wait for window manager ==========================
   # sleep 2;
   # ======================================================

   # === initialize X11 stuff =============================
   # Disable beep
   xset -b

   # load Xresources
   [ -e ~/.Xresources ]  && has_run xrdb ~/.Xresources
   
   # Set background to 'nearly black' (hack for fucking flash player)
   has_run xsetroot -solid '#000001'
 
   # Modify keyboard layout
   [ -e ~/.Xmodmap ]     && has_run xmodmap ~/.Xmodmap
  
   # Load additional keybindings
   [ -e ~/.xbindkeysrc ] && has_run xbindkeys

   # xset/setxkbmap
   has_run xset_daemon

   # Set background image if available
   has_run nitrogen --restore

   # Redshift
   has_run redshift

   # Set up our screensaver
   has_run xscreensaver -no-splash
   #xset dpms 0 0 $(( 60 * 10 ))
   #xscreensaver-command -lock
   # ======================================================

   # === Start terminal emulator ==========================
   sleep 1; 
   run $terminal_cmd $terminal_init;

} >LOG_FILE 2>&1 &

exec WINDOW_MANAGER

# vim: set syntax=sh:
