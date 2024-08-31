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
    let dir = home.appendingPathComponent("/Library/Calendars").path

    let files = [
      "Calendar.sqlitedb",
      "Calendar.sqlitedb-wal",
      "Extras.db",
      "Extras.db-shm",
      "Extras.db-wal",
    ].map { dir + "/" + $0 }
    let sketchybar = Sketchybar(event: "calendar_changed")
    let watcher = FileWatcher(paths: files, callback: sketchybar.trigger)
    watcher.start()

    dispatchMain()
  }
}
