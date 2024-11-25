property startup_script : "~/.config/bin/work.init.sh"

tell application "iTerm2"
  set W to create window with default profile 

  set S to current session of W
  tell S
    write text startup_script
  end tell
end tell
