import ArgumentParser
import EventKit
import Foundation
import Stencil

/// `plan next`
///
/// List next event(s)
struct Next: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List next event"
  )

  @Option(help: ArgumentHelp(
    "Fetch events within <m> minutes",
    valueName: "m"
  )) var within: Int = 60

  @Flag(help: ArgumentHelp(
    "Ignore all day events"
  ))
  var ignoreAllDayEvents: Bool = false

  @Option(help: ArgumentHelp(
    "Ignore titles matching the given pattern <p>",
    valueName: "p"
  )) var ignorePatternTitle: String = ""

  @Option(help: ArgumentHelp(
    "Ignore events which notes contain the tag <t> eg. 'tag:timeblock'. A comma separated list of tags.",
    valueName: "t"
  )) var ignoreTags: [String] = []

  @Option(help: ArgumentHelp(
    "Select calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var selectCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Ignore calendars <v>. A comma separated list of calendar UUIDs",
    valueName: "v"
  )) var ignoreCalendars: [String] = []

  @Option(help: ArgumentHelp(
    "Select calendar types <v>. A comma separated list of calendar types. Available: [local|caldav|exchange|subscription|bihrtyday]",
    valueName: "v"
  )) var selectCalendarTypes: [EKCalendarType] = []

  @Option(help: ArgumentHelp(
    "Ignore calendar types <v>. A comma separated list of calendar types. Available: [local|caldav|exchange|subscription|bihrtyday]",
    valueName: "v"
  )) var ignoreCalendarTypes: [EKCalendarType] = []

  @Option(help: ArgumentHelp(
    "Template path <p>.",
    valueName: "p"
  )) var templatePath: String = ""

  @Flag(help: ArgumentHelp(
    "Print debug statements"
  ))
  var debug: Bool = false

  mutating func run() {
    Log.setDebug(debug)

    let filterBefore = FiltersBefore.build(
      ignoreAllDayEvents: ignoreAllDayEvents,
      ignorePatternTitle: ignorePatternTitle,
      selectCalendars: selectCalendars,
      ignoreCalendars: ignoreCalendars,
      selectCalendarTypes: selectCalendarTypes,
      ignoreCalendarTypes: ignoreCalendarTypes
    )
    let filterAfter = FiltersAfter.build(
      ignoreTags: ignoreTags
    )
    let transformer = Transformers.id

    Log.write("next: About to call eventstore")

    let events = EventStore().next(
      within: within,
      selectCalendars: selectCalendars,
      filterBefore: filterBefore,
      filterAfter: filterAfter
    ).map { event in
      transformer(event)
    }.sorted { $0.schedule.end.inMinutes > $1.schedule.end.inMinutes }

    Log.write("next: Called eventstore")

    var next: [Event]
    if events.count == 0 {
      next = Array()
    } else {
      // prefix crashes if sequence has no elements
      next = Array(events.prefix(upTo: 1))
    }

    if templatePath.isEmpty {
      next.printAsJson()
    } else {
      let context = [
        "events": events,
      ]
      let environment = Environment(loader: DictionaryLoader(templates: ["index.html": "Hello World"]))
      let rendered = try! environment.renderTemplate(name: "index.html", context: context)
      print(rendered)
    }
  }
}
