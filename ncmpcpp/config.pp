####################################################
## this is example configuration file, copy it to ##
## ~/.ncmpcpp/config and set up your preferences  ##
####################################################
#
##### directories ######
##
## Directory for storing ncmpcpp related files.
## Changing it is useful if you want to store
## everything somewhere else and provide command
## line setting for alternative location to config
## file which defines that while launching ncmpcpp.
##
#
ncmpcpp_directory = ~/.config/ncmpcpp
#
##
## Directory for storing downloaded lyrics. It
## defaults to ~/.lyrics since other MPD clients
## (eg. ncmpc) also use that location.
##
#
#lyrics_directory = ~/.lyrics
#
##### connection settings #####
#
#mpd_host = 10.0.0.10
#
#mpd_port = 6600
#
#mpd_connection_timeout = 5
#
## Needed for tag editor and file operations to work.
##
mpd_music_dir = MUSIC_DIR
#
#mpd_crossfade_time = 5
#
##### music visualizer #####
##
## Note: In order to make music visualizer work you'll
## need to use mpd fifo output, whose format parameter
## has to be set to 44100:16:1 for mono visualization
## or 44100:16:2 for stereo visualization. Example
## configuration (it has to be put into mpd.conf):
##
## audio_output {
##        type            "fifo"
##        name            "Visualizer feed"
##        path            "/tmp/mpd.fifo"
##        format          "44100:16:2"
## }
##
#
visualizer_fifo_path = /tmp/mpd.fifo
#
##
## Note: Below parameter is needed for ncmpcpp
## to determine which output provides data for
## visualizer and thus allow syncing between
## visualization and sound as currently there
## are some problems with it.
##
#
visualizer_output_name = FIFO Mono
#
##
## If you set format to 44100:16:2, make it 'yes'.
##
visualizer_in_stereo = no
#
##
## Note: Below parameter defines how often ncmpcpp
## has to "synchronize" visualizer and audio outputs.
## 30 seconds is optimal value, but if you experience
## synchronization problems, set it to lower value.
## Keep in mind that sane values start with >=10.
##
#
visualizer_sync_interval = 30
#
##
## Note: To enable spectrum frequency visualization
## you need to compile ncmpcpp with fftw3 support.
##
#
## Available values: spectrum, wave, wave_filled, ellipse
##
visualizer_type = wave
#
visualizer_look = ●▮
#
#
##### system encoding #####
##
## ncmpcpp should detect your charset encoding
## but if it failed to do so, you can specify
## charset encoding you are using here.
##
## Note: You can see whether your ncmpcpp build
## supports charset detection by checking output
## of `ncmpcpp --version`.
##
## Note: Since MPD uses UTF-8 by default, setting
## this option makes sense only if your encoding
## is different.
##
#
#system_encoding = ""
#
##### delays #####
#
## Time of inactivity (in seconds) after playlist
## highlighting will be disabled (0 = always on).
##
#playlist_disable_highlight_delay = 5
#
## Defines how long messages are supposed to be visible.
##
message_delay_time = 2
#
##### song format #####
##
## for song format you can use:
##
## %l - length
## %f - filename
## %D - directory
## %a - artist
## %A - album artist
## %t - title
## %b - album
## %y - date
## %n - track number (01/12 -> 01)
## %N - full track info (01/12 -> 01/12)
## %g - genre
## %c - composer
## %p - performer
## %d - disc
## %C - comment
## %P - priority
## $R - begin right alignment
##
## you can also put them in { } and then it will be displayed
## only if all requested values are available and/or define alternate
## value with { }|{ } eg. {%a - %t}|{%f}
##
## Note: If you want to set limit on maximal length of a tag, just
## put the appropriate number between % and character that defines
## tag type, e.g. to make album take max. 20 terminal cells, use '%20b'.
##
## Note: Format that is similar to "%a - %t" (i.e. without any additional
## braces) is equal to "{%a - %t}", so if one of the tags is missing,
## you'll get nothing.
##
## text can also have different color than the main window has,
## eg. if you want length to be green, write "$3%l$9".
##
## Available values:
##
## - 0 - default window color (discards all other colors)
## - 1 - black
## - 2 - red
## - 3 - green
## - 4 - yellow
## - 5 - blue
## - 6 - magenta
## - 7 - cyan
## - 8 - white
## - 9 - end of current color
##
## Note: colors can be nested.
##
#song_list_format = {%a - }{%t}|{$8%f$9}$R{$3(%l)$9}
#
#song_status_format = {{%a{ "%b"{ (%y)}} - }{%t}}|{%f}
#
#song_library_format = {%n - }{%t}|{%f}
#
#tag_editor_album_format = {(%y) }%b
#
##
## Note: Below variables are used for sorting songs in browser.
## The sort mode determines how songs are sorted, and can be used
## in combination with a sort format to specify a custom sorting format.
## Available values for browser_sort_mode are "name", "mtime", "format"
## and "noop".
##
#
#browser_sort_mode = name
#
#browser_sort_format = {%a - }{%t}|{%f} {(%l)}
#
##
## Note: Below variables are for alternative version of user's interface.
## Their syntax supports all tags and colors listed above plus some extra
## markers used for text attributes. They are followed by character '$'.
## After that you can put:
##
## - b - bold text
## - u - underline text
## - r - reverse colors
## - a - use alternative character set
##
## If you don't want to use an attribute anymore, just put it again, but
## this time insert character '/' between '$' and attribute character,
## e.g. {$b%t$/b}|{$r%f$/r} will display bolded title tag or filename
## with reversed colors.
##
#
alternative_header_first_line_format = $1$aqqu$/a$9 $4{%t}|{%f} $1$atqq$/a$9
#
alternative_header_second_line_format = {{$5%a$9}{$8 - $2%b$9}{ ($4%y$9)}}|{%D}
#
##
## Note: below variables also support text attributes listed above.
##
#
#now_playing_prefix = $b
#
#now_playing_suffix = $/b
#
#browser_playlist_prefix = "$2playlist$9 "
#
#selected_item_prefix = $6
#
#selected_item_suffix = $9
#
#modified_item_prefix = $3> $9
#
## Note: colors are not supported for below variable.
##
#song_window_title_format = {%a - }{%t}|{%f}
#
##### columns settings #####
##
## syntax of song columns list format is "column column etc."
##
## - syntax for each column is:
##
## (width of column)[column's color]{displayed tag}
##
## Note: Width is by default in %, if you want a column to
## have fixed size, add 'f' after the value, e.g. (10)[white]{a}
## will be the column that take 10% of screen (so the real column's
## width will depend on actual screen size), whereas (10f)[white]{a}
## will take 10 terminal cells, no matter how wide the screen is.
##
## - color is optional (if you want the default one, type [])
##
## Note: You can give a column additional attributes by putting appropriate
## character after displayed tag character. Available attributes are:
##
## - r - column will be right aligned
## - E - if tag is empty, empty tag marker won't be displayed
##
## You can also:
##
## - give a column custom name by putting it after attributes,
##   separated with character ':', e.g. {lr:Length} gives you
##   right aligned column of lengths named "Length".
##
## - define sequence of tags, that have to be displayed in case
##   predecessor is empty in a way similar to the one in classic
##   song format, i.e. using '|' character, e.g. {a|c|p:Owner}
##   creates column named "Owner" that tries to display artist
##   tag and then composer and performer if previous ones are
##   not available.
##
#song_columns_list_format = (20)[]{a} (6f)[green]{NE} (50)[white]{t|f:Title} (20)[cyan]{b} (7f)[magenta]{l}
song_columns_list_format = "(5f)[magenta]{nE:#} (20)[blue]{a} (20)[red]{b} (50)[yellow]{t|f:Title} (7f)[green]{lr}"
#
##### various settings #####
#
##
## Note: Custom command that will be executed each
## time song changes. Useful for notifications etc.
##
## Attention: It doesn't support song format anymore.
## Use `ncmpcpp --now-playing SONG_FORMAT` instead.
##
#execute_on_song_change = ""
#
#playlist_show_remaining_time = no
#
#playlist_shorten_total_times = no
#
#playlist_separate_albums = no
#
##
## Note: Possible display modes: classic, columns.
##
playlist_display_mode = columns
#
browser_display_mode = classic
#
search_engine_display_mode = columns
#
#playlist_editor_display_mode = classic
#
#discard_colors_if_item_is_selected = yes
#
incremental_seeking = yes
#
seek_time = 5
#
#volume_change_step = 2
#
#autocenter_mode = no
#
#centered_cursor = no
#
##
## Note: You can specify third character which will
## be used to build 'empty' part of progressbar.
##
progressbar_look = "─╼─"
#
## Available values: database, playlist.
##
#default_place_to_search_in = database
#
## Available values: classic, alternative.
##
user_interface = classic
#
#data_fetching_delay = yes
#
## Available values: artist, album_artist, date, genre, composer, performer.
##
#media_library_primary_tag = artist
#
## Available values: wrapped, normal.
##
#default_find_mode = wrapped
#
## Available values: add, select, add_remove.
##
space_add_mode = add_remove
#
#default_tag_editor_pattern = %n - %t
#
header_visibility = no
#
statusbar_visibility = no
#
titles_visibility = no
#
header_text_scrolling = no
#
cyclic_scrolling = no
#
#lines_scrolled = 2
#
#follow_now_playing_lyrics = no
#
#fetch_lyrics_for_current_song_in_background = no
#
#store_lyrics_in_song_dir = no
#
generate_win32_compatible_filenames = no
#
allow_for_physical_item_deletion = no
#
##
## Note: If you set this variable, ncmpcpp will try to
## get info from last.fm in language you set and if it
## fails, it will fall back to english. Otherwise it will
## use english the first time.
##
## Note: Language has to be expressed as an ISO 639 alpha-2 code.
##
#lastfm_preferred_language = en
#
## Available values: add_remove, always_add.
##
#space_add_mode = always_add
#
#show_hidden_files_in_local_browser = no
#
##
## How shall screen switcher work?
##
## - "previous" - switch between the current and previous screen.
## - "screen1,...,screenN" - switch between given sequence of screens.
##
## Screens available for use: help, playlist, browser, search_engine,
## media_library, playlist_editor, tag_editor, outputs, visualizer, clock.
##
#screen_switcher_mode = playlist, browser
#
##
## Note: You can define startup screen for ncmpcpp
## by choosing screen from the list above.
##
#startup_screen = playlist
#
##
## Default width of locked screen (in %).
## Acceptable values are from 20 to 80.
##
#
#locked_screen_width_part = 50
#
ask_for_locked_screen_width_part = no
#
#jump_to_now_playing_song_at_start = yes
#
ask_before_clearing_playlists = yes
#
clock_display_seconds = yes
#
display_volume_level = no
#
#display_bitrate = no
#
#display_remaining_time = no
#
## Available values: none, basic, extended.
##
#regular_expressions = none
regular_expressions = basic
#
##
## Note: If below is enabled, ncmpcpp will ignore leading
## "The" word while sorting items in browser, tags in
## media library, etc.
##
ignore_leading_the = no
#
#block_search_constraints_change_if_items_found = yes
#
#mouse_support = yes
#
#mouse_list_scroll_whole_page = yes
#
empty_tag_marker = []
#
#tags_separator = " | "
#
#tag_editor_extended_numeration = no
#
#media_library_sort_by_mtime = no
#
#enable_window_title = yes
#
##
## Note: You can choose default search mode for search
## engine. Available modes are:
##
## - 1 - use mpd built-in searching (no regexes, pattern matching)
## - 2 - use ncmpcpp searching (pattern matching with support for regexes,
##       but if your mpd is on a remote machine, downloading big database
##       to process it can take a while
## - 3 - match only exact values (this mode uses mpd function for searching
##       in database and local one for searching in current playlist)
##
#
#search_engine_default_search_mode = 1
#
external_editor = vim
#
## Note: set to yes if external editor is a console application.
##
use_console_editor = yes
#
##### colors definitions #####
#
colors_enabled = yes
#
empty_tag_color = THEME_COLOR
#
header_window_color = THEME_COLOR
#
volume_color = default
#
state_line_color = blue
#
state_flags_color = default:b
#
main_window_color = THEME_COLOR
#
color1 = white
#
color2 = THEME_COLOR
#
#> if "NCMPCPP_VERSION" lt "0.9"
# WARNING: Variable 'main_window_highlight_color' is deprecated and will be removed in 0.9 (set current_item_prefix = "$(default)$r" and current_item_suffix = "$/r$(end)" to preserve current behavior).
main_window_highlight_color = default
#> endif
#
progressbar_color = black
#
progressbar_elapsed_color = THEME_COLOR
#
statusbar_color = THEME_COLOR
#
statusbar_time_color = THEME_COLOR
#
player_state_color = THEME_COLOR
#
alternative_ui_separator_color = black:b
#
#> if "NCMPCPP_VERSION" lt "0.9"
# WARNING: Variable 'active_column_color' is deprecated and will be removed in 0.9 (replaced by current_item_inactive_column_prefix and current_item_inactive_column_suffix).
active_column_color = red
#> endif
#
#visualizer_color = blue, cyan, green, yellow, magenta, red
visualizer_color = 41, 83, 119, 155, 185, 215, 209, 203, 197, 161
#
window_border_color = green
#
active_window_border = red
#



