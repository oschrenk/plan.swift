import ArgumentParser
import Foundation

/// `plan today`
///
/// List today's events
struct Today: ParsableCommand {
  static var configuration = CommandConfiguration(
    abstract: "List today's events"
  )

  @OptionGroup
  var todayOpts: SharedOptions

  mutating func run() {
    Log.setDebug(todayOpts.debug)

    let filterBefore = FiltersBefore.build(
      ignoreAllDayEvents: todayOpts.ignoreAllDayEvents,
      ignorePatternTitle: todayOpts.ignorePatternTitle,
      selectCalendars: todayOpts.selectCalendars,
      ignoreCalendars: todayOpts.ignoreCalendars,
      selectCalendarTypes: todayOpts.selectCalendarTypes,
      ignoreCalendarTypes: todayOpts.ignoreCalendarTypes
    )
    let filterAfter = FiltersAfter.build(
      ignoreTags: todayOpts.ignoreTags
    )

    let today = FCalendar.current.startOfDay(for: Date())
    let start = FCalendar.current.date(byAdding: .day, value: 0, to: today)!
    let end = FCalendar.current.date(byAdding: .day, value: 1, to: today)!

    let events = EventStore().fetch(
      start: start,
      end: end,
      selectCalendars: todayOpts.selectCalendars,
      filterBefore: filterBefore,
      filterAfter: filterAfter
    )

    if todayOpts.templatePath.isEmpty {
      events.printAsJson()
    } else {
      if let render = Template.render(path: todayOpts.templatePath, events: events) {
        print(render)
      } else {
        StdErr.print("Failed to render template at `\(todayOpts.templatePath)`")
      }
    }
  }
}
