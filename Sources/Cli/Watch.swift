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
    let config = Loader.readConfig()
    StdOut.print("\(String(describing: config))")
    let hooks = config?.hooks ?? []
    repo.registerForEventStoreChanges(hooks: hooks)
    dispatchMain()
  }
}
