### Reload Tmux-Source
#
#> define RELOAD source-file ~/.tmux.conf

### Our "perl-tmux-daemon"
#
#> define TMUX_DAEMON_BIN tmux_daemon.pl
#> define TMUX_DAEMON_BIN_DIR ~/.tmux/bin
#> if "HAVE_DEV_SHM" eq "1"
	#> define TMUX_DAEMON_FIFO /dev/shm/$USER-tmux-daemon.fifo
#> else
	#> define TMUX_DAEMON_FIFO /tmp/.$USER-tmux-daemon.fifo
#> endif
#> define TMUX_DAEMON(_ACTION_) run -b 'echo _ACTION_ > TMUX_DAEMON_FIFO ;:'
#
# Also ensure that our demon is running:
run 'pkill -U $USER -f TMUX_DAEMON_BIN &>/dev/null;:'
run -b "TMUX_DAEMON_BIN_DIR/TMUX_DAEMON_BIN TMUX_DAEMON_FIFO &>/dev/null;:"


# delete all keybindings
unbind -a
bind -n "'" TMUX_DAEMON(test)

# enable mouse
set -g mouse on

# use ^a as prefix
set -g prefix '^a'

# use ^aa for sending ^a
bind 'a' send-prefix

###
set -g default-shell 'DEFAULT_SHELL'
set -g automatic-rename on

### keys ###
set -g status-keys 'vi'
set -g mode-keys   'vi'

### status bar ####
set -g status-interval 1
set -g status-style       'bg=black,fg=white'
set -g status-left-style  'bg=black,fg=white'
set -g status-right-style 'bg=black,fg=white'

set -g status-left ' '
set -g status-left-length 0

set -g status-right '%T'
set -g status-right-length 10

set -g window-status-format "#I:#W"
set -g window-status-style  'bg=black,fg=THEME_COLOR'

set -g window-status-current-format "#I:#W"
set -g window-status-current-style  'bg=black,fg=white,bold'

set -g window-status-last-style 'bg=black,fg=white'
set -g window-status-bell-style 'bg=black,fg=red'

set -g default-terminal "screen-256color"

set -g display-time 3000

# don't resize all the windows to the smallest
# session, resize only the active window in the small session.
set -g aggressive-resize on

### ### ### Mouse stuff

### ### STATUS BAR
### Mouse Wheel:
 bind -n   'WheelUpStatus'      previous-window
 bind -n   'WheelDownStatus'    next-window

### Left Click: selects window
 bind -n   'MouseDown1Status'   select-window -t=
### Left Drag:  moves window
 bind -n   'MouseDrag1Status'   swap-window -t=

### Middle Click: closes window
 bind -n   'MouseDown2Status'   display-message "Window will be killed. Drag to abort"
### Middle Drag: swaps window
 bind -n   'MouseDrag2Status'   swap-window -t=
### Middle Up:
 bind -n   'MouseUp2Status'     kill-window -t=

### Right Click:  selects window
 bind -n   'MouseDown3Status'   run -b '~/.tmux/bin/menu'
### Right Drag:   moves window
#bind -n   'MouseDrag3Status'   swap-window -t=
### Right: Up:    closes window
#bind -n   'MouseUp3Status'     kill-window -t=


### ### PANE BORDERS
### Mouse Wheel:
 bind -n   'WheelUpBorder'      send-keys Up Up Up Up
 bind -n   'WheelDownBorder'    send-keys Down Down Down Down
 bind -n 'C-WheelUpBorder'      send-keys Up Up Up Up
 bind -n 'C-WheelDownBorder'    send-keys Down Down Down Down

### Left Click: selects pane
#bind -n   'MouseDown1Border'   select-pane -t=
### Left Drag: resizes pane
 bind -n   'MouseDrag1Border'   resize-pane -M

### Middle Click: selects pane
#bind -n   'MouseDown2Border'   select-pane -t=
### Middle Up: breaks pane
 bind -n   'MouseUp2Border'     break-pane -d -t '='
### Middle Drag: resizes pane
 bind -n   'MouseDrag2Border'   resize-pane -M

### Right Click: selects-pane
#bind -n   'MouseDown3Border'   select-pane -t=
### Right Up: breaks pane
 bind -n   'MouseUp3Border'     break-pane -d -t '='
### Right Drag: resizes pane
 bind -n   'MouseDrag3Border'   resize-pane -M

### ### PANES
### Mouse Wheel:
 bind -n   'WheelUpPane'        send-keys Up Up Up Up
 bind -n   'WheelDownPane'      send-keys Down Down Down Down
 bind -n 'C-WheelUpPane'        send-keys Up
 bind -n 'C-WheelDownPane'      send-keys Down

### Left Click: selects pane and clicks
# bind -n   'MouseDown1Pane'     select-pane -t= \; send-keys -M
### Left Drag:  enters selection mode
 bind -n   'MouseDrag1Pane'     copy-mode -M \; 
 bind -n 'C-MouseDrag1Pane'     unbind -n 'MouseDrag1Pane' \; copy-mode \; bind -n 'MouseDrag1Pane' copy-mode -M
### Left Up:
 bind -n   'MouseUp1Pane'       select-pane -t= \; send-keys -M

### Middle Click: paste buffser
 bind -n   'MouseDown2Pane'     select-pane -t= \; paste-buffer
### C-Middle-Click:
 bind -n 'C-MouseDown2Pane'     join-pane -s '{marked}' -t=

### Right Click: toggle mark
 bind -n   'MouseDown3Pane'     select-pane -t= -m \; send-keys -M
### Right Drag:  swap panes
 bind -n   'MouseDrag3Pane'     swap-pane -s '='


#bind -n 'C-MouseDown1Pane' select-pane -t= -m \; # NEXT_JOIN_PANE
#bind -n 'C-MouseDown1Status' break-pane -d -s '{marked}'

#bind -n 'C-MouseDown3Pane' 
#bind -n 'MouseDrag3Border' swap-pane -s '{marked}' -t=
#bind -n 'MouseDrag1Pane' select-pane -t= -m 

# joining panes
#bind -n 'C-MouseDown1Pane' join-pane -s    '{marked}'
#bind -n 'C-MouseDown3Pane' join-pane -h -s '{marked}'

#bind -n 'MouseDown1Pane'  select-pane -t= \; select-pane -t= -m \; send-keys -M
#bind -n 'MouseDown1Pane'  select-pane -t '=' -P 'bg=black' \; select-pane -P 'bg=black' -l \; send-keys -M
#bind -n 'MouseDown3Pane'  select-pane -P 'bg=default' \; select-pane -P 'bg=black' -t '=' \; select-pane -t '=' -M \; send-keys -M

# swappng panes
#bind -n 'MouseDrag3Pane'   select-pane -t '=' -M \; send-keys -M
#bind -n 'MouseUp3Pane'     swap-pane -t '='

# splitting panes
#bind -n 'C-MouseDown1Border' split-window
#bind -n 'C-MouseDown3Border' split-window -h


# misc bindings
bind ':'  command-prompt
bind '^r' source ~/.tmux.conf
bind '^l' refresh-client
bind 'g'  set status

bind 'PageUp'   copy-mode -u
bind '^u'       copy-mode -u
bind 'PageDown' copy-mode
bind 'p' paste-buffer


bind 'D' detach
bind '?'  list-keys
bind -n 'F1' set -g mouse '' 

# clipboard actions
#> define XSEL xsel -l /dev/null
#> define TIMEOUT timeout -k 1 2 
#> define BUF_FILE "/tmp/.tmuxbuf"
bind   'C' run -b 'tmux show-buffer | TIMEOUT XSEL -i -p ;:'
bind 'C-C' run -b 'tmux show-buffer | TIMEOUT XSEL -i -b ;:'
bind   'v' paste-buffer

# paste from X11 clipboard, preserve old buffer in BUF_FILE
bind   'V' save-buffer BUF_FILE \;\
           delete-buffer \;\
           run 'TIMEOUT XSEL -o -p | tmux load-buffer -b primary - ;:' \;\
           paste-buffer -r -d -b primary \;\
           load-buffer BUF_FILE
bind 'C-V' save-buffer BUF_FILE \;\
           delete-buffer \;\
           run 'TIMEOUT XSEL -o -b | tmux load-buffer -b clipboard - ;:' \;\
           paste-buffer -r -d -b clipboard \;\
           load-buffer BUF_FILE

# 'V'/'C-V' will fail on 'save-buffer' if there is no buffer present.
set-buffer ' '

# pane control
bind -r 'M-h'  resize-pane -L
bind -r 'M-j'  resize-pane -D
bind -r 'M-k'  resize-pane -U
bind -r 'M-l'  resize-pane -R

# breaking/joining panges
bind 'B'       break-pane
bind 'J'       display-message 'Join direction? _ horizontal | vertical' \; switch-client -T jp
bind -T jp '_' choose-window 'join-pane -v -s %%'
bind -T jp '|' choose-window 'join-pane -h -s %%'

# pane selection
bind 'H'       select-pane -L
bind 'j'       select-pane -D
bind 'k'       select-pane -U
bind 'L'       select-pane -R

# window splitting
bind '_'       split-window
bind '|'       split-window -h

# window moving
bind 'm'       TMUX_DAEMON(move-window-interactive)

# window selection
bind ' '       choose-tree -u
bind '"'       choose-window
bind '`'       TMUX_DAEMON(select-window 0)
bind '1'       TMUX_DAEMON(select-window 1)
bind '2'       TMUX_DAEMON(select-window 2)
bind '3'       TMUX_DAEMON(select-window 3)
bind '4'       TMUX_DAEMON(select-window 4)
bind '5'       TMUX_DAEMON(select-window 5)
bind '6'       TMUX_DAEMON(select-window 6)
bind '7'       TMUX_DAEMON(select-window 7)
bind '8'       TMUX_DAEMON(select-window 8)
bind '9'       TMUX_DAEMON(select-window 9)
bind '0'       TMUX_DAEMON(select-window 10)
bind '-'       TMUX_DAEMON(select-window 11)
bind '='       TMUX_DAEMON(select-window 12)
bind 'BSpace'  TMUX_DAEMON(select-window 13)
bind 'Home'    TMUX_DAEMON(select-window 14)
bind 'End'     TMUX_DAEMON(select-window 15)
bind 'F1'      TMUX_DAEMON(select-window 11)
bind 'F2'      TMUX_DAEMON(select-window 12)
bind 'F3'      TMUX_DAEMON(select-window 13)
bind 'F4'      TMUX_DAEMON(select-window 14)
bind 'F5'      TMUX_DAEMON(select-window 15)
bind 'F6'      TMUX_DAEMON(select-window 16)
bind 'F7'      TMUX_DAEMON(select-window 17)
bind 'F8'      TMUX_DAEMON(select-window 18)
bind 'F9'      TMUX_DAEMON(select-window 19)
bind 'F10'     TMUX_DAEMON(select-window 20)
bind 'F11'     TMUX_DAEMON(select-window 21)
bind 'F12'     TMUX_DAEMON(select-window 22)

# session selection
#bind -T SeSe '`'     TMUX_DAEMON(select-session 0)
#bind -T SeSe '1'     TMUX_DAEMON(select-session 1)
#bind -T SeSe '2'     TMUX_DAEMON(select-session 2)
#bind -T SeSe '3'     TMUX_DAEMON(select-session 3)
#bind -T SeSe '4'     TMUX_DAEMON(select-session 4)
#bind -T SeSe '5'     TMUX_DAEMON(select-session 5)
#bind -T SeSe '6'     TMUX_DAEMON(select-session 6)
#bind -T SeSe '7'     TMUX_DAEMON(select-session 7)
#bind -T SeSe '8'     TMUX_DAEMON(select-session 8)
#bind -T SeSe '9'     TMUX_DAEMON(select-session 9)
#bind -T SeSe '0'     TMUX_DAEMON(select-session 10)
#bind -T SeSe 'j'     TMUX_DAEMON(select-session -n)
#bind -T SeSe 'k'     TMUX_DAEMON(select-session -p)
#bind -T SeSe 'S'     choose-session
#bind 'S'       switch-client -T SeSe

bind '/'       command-prompt "find-window -TN %%"
bind 'R'       move-window -r

#bind 'f'       TMUX_DAEMON(history-forward)
#bind 'b'       TMUX_DAEMON(history-backward)
bind 'B'       move-window -t bg:

bind '^a'      last-window
bind 'h'       previous-window
bind 'l'       next-window

# window creation and command execution
bind 'c'       neww
#bind 'o'       neww 'runner -H ~/.tmux/url_hist  -C -t "$HOME/.tmux/bin/w3m_openurl" -P url'
#bind 's'       neww 'runner -H ~/.tmux/srch_hist -C -t "$HOME/.tmux/bin/websearch" -P srch'
#bind 'n'       neww "runner -H ~/.tmux/cmd_hist -P cmd"
#bind 'r'       neww "runner -H ~/.tmux/cmd_hist -b -q -P cmd"

# vim: set filetype=tmux.conf:

