import ArgumentParser
import EventKit
import Foundation

/// `plan today`
///
/// List today's events
struct Today: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List today's events"
  )

  @Option(help: ArgumentHelp(
    "Template path <p>.",
    valueName: "p"
  )) var templatePath: String = ""

  @Option(help: ArgumentHelp(
    "Ignore events which notes contain the tag <t> eg. 'tag:timeblock'. A comma separated list of tags.",
    valueName: "t"
  )) var ignoreTags: [String] = []

  @Flag(help: ArgumentHelp(
    "Print debug statements"
  ))
  var debug: Bool = false

  @Option(help: ArgumentHelp(
    "Select calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var selectCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Ignore calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendars: [String] = []

  mutating func run() {
    Log.setDebug(debug)

    let filterBefore = FiltersBefore.build(
      ignoreAllDayEvents: false,
      ignorePatternTitle: "",
      ignoreCalendars: ignoreCalendars
    )
    let filterAfter = FiltersAfter.build(ignoreTags: ignoreTags)

    let events = EventStore().today(
      selectCalendars: selectCalendars,
      filterBefore: filterBefore,
      filterAfter: filterAfter
    )

    if templatePath.isEmpty {
      events.printAsJson()
    } else {
      let render = Template.render(path: templatePath, events: events)
      if render == nil {
        StdErr.print("Failed to render template at `\(templatePath)")
      } else {
        print(render!)
      }
    }
  }
}
