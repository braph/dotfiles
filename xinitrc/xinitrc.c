#define LOG_FILE "/dev/null"
#define LOG_FILE "/tmp/xinitrc.$USER.$$.WINDOW_MANAGER.log"

int has(String command) {
   return CmdOk Exec("which", command);
}

run() {
   "$@" &
}

#define has_run2(args...) _has_run2( Strings(args) )
int _has_run2(Strings args) {
   if (has(args[0])) {
      run(args);
      return 1;
   }

   return 0;
}

#define has_run(args...) _has_run(args)
BeginFunction(_has_run)
   if (has(args[0])) {
      run(args);
      Return(1);
   }

   Return(0);
EndFunction();

ErrToFile(LOG_FILE);
OutToFile(LOG_FILE);

Sh("date"); // date for log file

// === Dirs that we want to keep in /tmp ================
String USER_TMP_DIR = "/tmp/home-temp-${USER}";

// TODO? mozilla stuff?
// .cache \

Foreach(dir, Strings(".adobe", ".macromedia"))
   Echo("Linking %s to temp", dir);
   CmdOk Sh("rm -rf ~/%s", dir);
   CmdOk Sh("mkdir -p '%s/%s'",     USER_TMP_DIR, dir) &&
   CmdOk Sh("chmod 0755 '%s/%s'",   USER_TMP_DIR, dir) &&
   CmdOk Sh("ln -s '%s/%s' ~/'%s'", USER_TMP_DIR, dir, dir);
Done
// ======================================================

// === Music Player Daemon ==============================
has_run("mpd");

// === Our notification daemon ===
has_run("dunst");

// === Remap Mousebuttons ===
has_run("imwheel");

// === Disable touchpad while typing ===
has_run("syndaemon", "-i", "0.5", "-t", "-K", "-R");

// === Open browser =====================================
#ifndef STARTPAGE
#  define STARTPAGE blog.fefe.de
#endif
has_run("bnox"     , "STARTPAGE") ||
has_run("inox"     , "STARTPAGE") ||
has_run("chromium" , "STARTPAGE") ||
has_run("palemoon" , "STARTPAGE") ||
has_run("firefox"  , "STARTPAGE") ||
has_run("dillo"    , "STARTPAGE") ;

// === Host based applications ==========================
#if "HOST" eq "pizwo"
 // has_run synergys
#elif "HOST" eq "samsung"
 // has_run synergyc 10.0.0.10
#endif

// === Select terminal emulator =========================
String terminal_cmd;

If has("uxterm") Then
   terminal_cmd = "uxterm -maximized -e";
Elif has("xterm") Then
   terminal_cmd = "xterm -maximized -e";
Elif has("evilvte") Then
   terminal_cmd = "evilvte -f -e";
Elif has("terminator") Then
   terminal_cmd = "terminator -f -b -x";
Fi
   
// ======================================================

// === Select terminal init =============================
String terminal_init;

If has("tmux") Then
   If CmdError Exec("tmux", "has-session", "-t", "main") Then
      Exec("tmux", "new-session", "-d", "-s", "main");
   Fi

   If CmdError Exec("tmux", "has-session", "-t", "bg") Then
      Exec("tmux", "new-session", "-d", "-s", "bg")
   Fi

   // has ncmpcpp && tmux new-window -t 'main:' 'ncmpcpp'
   // { has finch   && tmux new-window -t 'main:' 'finch';   } ||
   // { has mcabber && tmux new-window -t 'main:' 'mcabber'; } 

   terminal_init = "tmux -2 attach -t main";
Elif has("zsh") Then
   terminal_init = "zsh";
Else
   terminal_init = "bash";
Fi
// ======================================================

// === Wait for window manager ==========================
// sleep 2;
// ======================================================

// === initialize X11 stuff =============================
// Disable beep
Exec("xset", "-b");

// load Xresources
If FileExists("~/.Xresources") Then
   has_run("xrdb", "~/.Xresources");
Fi

// Set background to 'nearly black' (hack for fucking flash player)
has_run("xsetroot", "-solid", "#000001");

// Modify keyboard layout
If FileExists("~/.Xmodmap") Then
   has_run("xmodmap", "~/.Xmodmap");
Fi

// Load additional keybindings
If FileExists("~/.xbindkeysrc") Then
   has_run("xbindkeys");
Fi

// xset/setxkbmap
has_run("xset_daemon");

// Set background image if available
has_run("nitrogen", "--restore");

// Redshift
has_run("redshift");

// Set up our screensaver
has_run("xscreensaver", "-no-splash");
//xset dpms 0 0 $(( 60 * 10 ))
//xscreensaver-command -lock
// ======================================================

// === Start terminal emulator ==========================
sleep(1); 

String cmd;
FormatString(&cmd, "%s %s", terminal_cmd, terminal_init);
Sh(cmd);
Free(cmd);

execlp(WINDOW_MANAGER, NULL);
