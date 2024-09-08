import ArgumentParser
import EventKit
import Foundation

/// `plan next`
///
/// List next event(s)
struct Next: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List next event(s)"
  )

  @OptionGroup
  var nextOpts: SharedOptions

  @Option(help: ArgumentHelp(
    "Fetch events within <m> minutes",
    valueName: "m"
  )) var within: Int = 60

  mutating func run() {
    Log.setDebug(nextOpts.debug)

    let filterBefore = FiltersBefore.build(
      ignoreAllDayEvents: nextOpts.ignoreAllDayEvents,
      ignorePatternTitle: nextOpts.ignorePatternTitle,
      selectCalendars: nextOpts.selectCalendars,
      ignoreCalendars: nextOpts.ignoreCalendars,
      selectCalendarTypes: nextOpts.selectCalendarTypes,
      ignoreCalendarTypes: nextOpts.ignoreCalendarTypes
    )
    let filterAfter = FiltersAfter.build(
      ignoreTags: nextOpts.ignoreTags
    )

    Log.write("next: About to call eventstore")

    let events = EventStore().next(
      within: within,
      selectCalendars: nextOpts.selectCalendars,
      filterBefore: filterBefore,
      filterAfter: filterAfter
    ).sorted { $0.schedule.end.inMinutes > $1.schedule.end.inMinutes }

    Log.write("next: Called eventstore")

    let next = Array(events.prefix(1))

    if nextOpts.templatePath.isEmpty {
      next.printAsJson()
    } else {
      if let render = Template.render(path: nextOpts.templatePath, events: next) {
        StdOut.print(render)
      } else {
        StdErr.print("Failed to render template at `\(nextOpts.templatePath)`")
      }
    }
  }
}
