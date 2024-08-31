import ArgumentParser
import Foundation

/// `plan watch`
///
/// Watch for calendar changes
struct Watch: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Fire Sketchybar event on calendar changes"
  )

  @Option(help: ArgumentHelp(
    "Sketchybar event <e>.",
    valueName: "e"
  )) var sketchybarEvent: String = "calendar_changed"

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
      callback: Sketchybar(event: sketchybarEvent).trigger
    ).start()

    dispatchMain()
  }
}
