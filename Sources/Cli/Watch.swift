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
    let repo = EventRepo()
    let hooks = Loader.readConfig()?.hooks ?? []
    repo.registerForEventStoreChanges(hooks: hooks)
    dispatchMain()
  }
}
