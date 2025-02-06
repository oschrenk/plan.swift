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
    let config = Loader.readConfig()
    EventRepo().registerForEventStoreChanges(hooks: config?.hooks ?? [])
    dispatchMain()
  }
}
