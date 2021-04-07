### Reload Tmux-Source
#
#> define RELOAD source-file ~/.tmux.conf

# delete all keybindings
unbind -a

# enable mouse
set -g mouse on

# more scrollback
set -g history-limit 32786

# use ^a as prefix
set -g prefix '^a'

# use ^b as prefix if inside ssh
if -F "#{SSH_CLIENT}" 'set -g prefix2 ^b' ''

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

set -g status-right "#[fg=magenta]%H#[fg=blue]%M#[fg=cyan]%S#[fg=black,bold]#(sed 's/^//; s/$/%/' /sys/class/power_supply/BAT0/capacity)"
#set -g status-right-length 

set -g window-status-format "#I#[fg=THEME_COLOR]#W"
set -g window-status-style  'bg=black,fg=black,bold'

set -g window-status-current-format "#I#[fg=white]#W"
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

# window selection
bind ' '       choose-tree
bind '"'       choose-window
bind '`'       select-window -t 0
bind '1'       select-window -t 1
bind '2'       select-window -t 2
bind '3'       select-window -t 3
bind '4'       select-window -t 4
bind '5'       select-window -t 5
bind '6'       select-window -t 6
bind '7'       select-window -t 7
bind '8'       select-window -t 8
bind '9'       select-window -t 9
bind '0'       select-window -t 10
bind '-'       select-window -t 11
bind '='       select-window -t 12
bind 'BSpace'  select-window -t 13
bind 'Home'    select-window -t 14
bind 'End'     select-window -t 15
bind 'F1'      select-window -t 11
bind 'F2'      select-window -t 12
bind 'F3'      select-window -t 13
bind 'F4'      select-window -t 14
bind 'F5'      select-window -t 15
bind 'F6'      select-window -t 16
bind 'F7'      select-window -t 17
bind 'F8'      select-window -t 18
bind 'F9'      select-window -t 19
bind 'F10'     select-window -t 20
bind 'F11'     select-window -t 21
bind 'F12'     select-window -t 22
bind 'IC'      select-window -t 23 # Insert, laptop
bind 'DC'      select-window -t 24 # Delete, laptop

bind '/'       command-prompt "find-window -TN %%"
bind 'R'       move-window -r

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

# Run Tmux Perl Daemon
run -b 'tmux-daemon'

# vim: set filetype=tmux.conf:
