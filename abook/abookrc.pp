#> ifndef THEME_COLOR
#> define THEME_COLOR blue
#> endif

### Fields ###
field birthday = "Geburtstag", date
field notes_list = "Notizen", list

view Kontakt = nick, name, email, birthday, url, notes_list

view Adresse = address, city, state, zip, country

view Telefon = phone, workphone, mobile, fax

field jabber = "Jabber", list
field skype  = "Skype"
field icq    = "ICQ"
field facebook = "Facebook"
field youtube = "Youtube"
view Messenger = jabber, skype, icq, facebook, youtube

field iban = "IBAN"
field bic  = "BIC"
field kontonr = "Konto-Nr."
field blz = "Bankleitzahl"
view Bank = iban, bic, kontonr, blz


### Options ###
set autosave = false

set preserve_fields = all

set index_format = "{name}"

set use_ascii_only = false

set add_email_prevent_duplicates = true

set sort_field = "name"

set show_cursor = false

set use_colors = true

### Keybindings ###

### Theme ###
set color_header_fg = "white"
set color_header_bg = "default"

set color_footer_fg = "white"
set color_footer_bg = "default"

set color_list_header_fg = "white"
set color_list_header_bg = "black"

set color_list_even_fg = "white"
set color_list_even_bg = "default"
set color_list_odd_fg = "THEME_COLOR"
set color_list_odd_bg = "default"

set color_list_highlight_fg = "black"
set color_list_highlight_bg = "white"

set color_tab_border_fg = "white"
set color_tab_border_bg = "default"

set color_tab_label_fg = "THEME_COLOR"
set color_tab_label_bg = "default"

set color_field_name_fg = "THEME_COLOR"
set color_field_name_bg = "default"

set color_field_value_fg = "white"
set color_field_value_bg = "default"
