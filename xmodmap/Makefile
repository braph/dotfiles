KEYBOARD_BASE_LAYOUT = us
REMAP_NUMPAD = 1
GERMANIZE = 1

PP_FILES = Xmodmap
FILEPP_PREFIX = !>

.post_install::
	-setxkbmap $(KEYBOARD_BASE_LAYOUT)
	-xmodmap ~/.Xmodmap

include ../dotfile.mk
