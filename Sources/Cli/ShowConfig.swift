import ArgumentParser
import EventKit
import Foundation

/// `plan config`
///
/// Show config
struct ShowConfig: ParsableCommand {
  static var configuration = CommandConfiguration(
    commandName: "config",
    abstract: "Show config",
    shouldDisplay: false
  )

  mutating func run() {
    let config = Loader.readConfig()
    StdOut.print("\(String(describing: config))")
  }
}
