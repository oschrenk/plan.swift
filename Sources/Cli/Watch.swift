import ArgumentParser
import Foundation

/// `plan watch`
///
/// Watch for calendar changes
struct Watch: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Fire hook event on calendar changes"
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

    FileWatcher(
      paths: files,
      callback: Sketchybar(event: "calendar_changed").trigger
    ).start()

    dispatchMain()
  }
}
