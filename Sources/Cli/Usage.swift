import ArgumentParser
import EventKit
import Foundation

/// `plan usage`
///
/// Show usage and version
struct Usage: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Show help",
    shouldDisplay: false
  )

  @Flag(help: ArgumentHelp(
    "Show version"
  ))
  var version: Bool = false

  mutating func run() {
    if version {
      StdOut.print(Version.value)
    } else {
      StdOut.print(Cli.helpMessage())
    }
  }
}
