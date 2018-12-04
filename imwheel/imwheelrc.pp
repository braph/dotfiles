# Consider using xbindkeys instead, if you don't need
# per application settings

#> ifndef SCROLL_BROWSER_LINES
#> define SCROLL_BROWSER_LINES 1
#> endif
#
#> ifndef SCROLL_BROWSER_LINES_SHIFT
#> define SCROLL_BROWSER_LINES_SHIFT 1
#> endif

# List of all possible browser titles, separated by pipe (|)
#> define BROWSERS \
Palemoon|\
Pale Moon|\
Mozilla Firefox|\
Firefox|\
Chromium|\
Inox|\
Bnox|\
Dillo

# "Mozilla Firefox"
# "Website Foo Bar - Mozilla Firefox"
# "Website Foo Bar - Pale Moon"
# "Website Foo Bar - Pale Moon (Private Browsing)"
"^(.* - )?(BROWSERS)( \(Private Browsing\))?$"
Control_L,  Up,   Control_L|plus 
Control_L,  Down, Control_L|minus
Shift_L,    Up,   Button4, SCROLL_BROWSER_LINES_SHIFT
Shift_L,    Down, Button5, SCROLL_BROWSER_LINES_SHIFT
None,       Up,   Button4, SCROLL_BROWSER_LINES
None,       Down, Button5, SCROLL_BROWSER_LINES

".*"
None, Thumb2, Page_Up
None, Thumb1, Page_Down
