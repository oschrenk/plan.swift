import ArgumentParser
import EventKit
import Foundation

/// Plan is a CLI tool to fetch and display events and calendars
///
/// This the main entry point
@main
struct Main: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Unofficial Calendar.app companion CLI to view today's events in various forms",
    subcommands: [
      Add.self,
      Calendars.self,
      Hours.self,
      Next.self,
      On.self,
      ShowConfig.self,
      Today.self,
      Usage.self,
      Watch.self,
    ],
    defaultSubcommand: Usage.self
  )

  mutating func run() {}
}
