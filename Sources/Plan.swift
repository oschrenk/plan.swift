import ArgumentParser
import EventKit
import Foundation

@main
struct Plan: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "Unofficial Calendar.app companion CLI to view today's events in various forms",
    subcommands: [
      Add.self,
      Calendars.self,
      Next.self,
      Today.self,
      Usage.self,
      Watch.self,
    ],
    defaultSubcommand: Usage.self
  )

  mutating func run() {}
}
