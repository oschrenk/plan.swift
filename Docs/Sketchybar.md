# Sketchybar

You can use `plan` to show the next calendar event with sketchybar

# Advanced

If you intend to use the `plan watch` feature to monitor the `~/Library/Calendars` directory to fire Sketchybar events, you need to give `/opt/homebrew/bin/plan` "Full Disk access".

macOS protects files in `~/Library/` from potential malicious access.

You can give `plan` access, by opening "System Settings > Privacy & Security > Full Disk Access", Click on the "+" icon, and navigate to `/opt/homebrew/bin/plan` (Cmd+Shift+G in the Finder lets you navigate more directly by typing)

This is different from the access to the actual "Calendar" app. macOS will actually prompt you for that.

