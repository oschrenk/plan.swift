import ArgumentParser
import Foundation

/// `plan watch`
///
/// Watch for calendar changes
struct Watch: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Watch for changes",
    shouldDisplay: false
  )

  mutating func run() {
    let home = FileManager.default.homeDirectoryForCurrentUser
    let dir = home.path + "/Library/Calendars"
    let files = [
      dir + "/Calendar.sqlitedb",
      dir + "/Calendar.sqlitedb-wal",
      dir + "/Extras.db",
      dir + "/Extras.db-shm",
      dir + "/Extras.db-wal",
    ]
    let sketchybar = Sketchybar(event: "calendar_changed")
    let watcher = FileWatcher(paths: files, callback: sketchybar.trigger)
    watcher.start()

    dispatchMain()
  }
}
