#> ifndef FONTSIZE
#> define FONTSIZE 13
#> endif

! ======== X11 Cursor ==========================
Xcursor.theme: oxy-steel
Xcursor.size:  32

! ======== General Terminal Settings ===========
#> foreach TERM xterm, UXTerm, URxvt

! Cursor
TERM*cursorColor: Red
TERM*cursorBlink: true

! Title
TERM*title: Terminal

! Fixes ALT-Key
TERM*metaSendsEscape: true

! Disable changing window title
TERM*allowTitleOps: false

! UTF-8 Stuff
TERM*utf8:            2
TERM*eightBitInput:   true

! Geometry
TERM*geomentry: 120x80

! Scrollbar
TERM*scrollBar: false
TERM*saveLines: 0

! Very important, do not hang if many lines are written
TERM*fastScroll: True
TERM*jumpScroll: True

! Font
TERM*faceName:  Hack:size=FONTSIZE
!TERM*.faceName:  xft:DejaVu Sans Mono:size=FONTSIZE
TERM*cjk_width:  true
TERM*faceNameDoublesize:  xft:DejaVu Sans Mono:size=FONTSIZE


! === Color Scheme ===
#> include COLOR_THEME
! Overwrite Background/Foreground
TERM*background: #111111
TERM*foreground: #EEEEEE
! ====================

#> endforeach
! ============================================

! === URxvt ====
URxvt.font: xft:Hack:size=FONTSIZE
URxvt.letterSpace: -1
URxvt*buffered: false
! ==============

! === xterm bindings ===
*VT100.Translations: #override \n\
      !Ctrl                <Btn1Down>:    ignore() \n\
      !Lock Ctrl           <Btn1Down>:    ignore() \n\
      !Lock Ctrl @Num_Lock <Btn1Down>:    ignore() \n\
      ! @Num_Lock Ctrl     <Btn1Down>:    ignore() \n\
      \
      !Ctrl                <Btn2Down>:    ignore() \n\
      !Lock Ctrl           <Btn2Down>:    ignore() \n\
      !Lock Ctrl @Num_Lock <Btn2Down>:    ignore() \n\
      ! @Num_Lock Ctrl     <Btn2Down>:    ignore() \n\
      \
      !Ctrl                <Btn3Down>:    ignore() \n\
      !Lock Ctrl           <Btn3Down>:    ignore() \n\
      !Lock Ctrl @Num_Lock <Btn3Down>:    ignore() \n\
      ! @Num_Lock Ctrl     <Btn3Down>:    ignore() \n\


! === Font ===
Xft.antialias: 1
Xft.autohint: 0
Xft.dpi: 96
Xft.hinting: 1
!Xft.hintstyle: hintfull
Xft.hintstyle: hintslight
Xft.lcdfilter: lcddefault
Xft.rgba: rgb
! ============

