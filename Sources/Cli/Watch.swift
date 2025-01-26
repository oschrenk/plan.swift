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
    StdOut.print("111")
    print("111a")
    let repo = EventRepo()
    StdOut.print("222")
    print("bbb")
    let config = Loader.readConfig()
    StdOut.print("\(String(describing: config))")
    let hooks = config?.hooks ?? []
    repo.registerForEventStoreChanges(hooks: hooks)
    dispatchMain()
  }
}
