import EventKit
import Foundation

struct Service {
  let store = EventStore()

  func today(
    ignoreTag: String,
    ignoreCalendars: [String]
  ) -> [Event] {
    let filterBefore = Refine.before(
      ignoreAllDayEvents: false,
      ignorePatternTitle: "",
      ignoreCalendars: ignoreCalendars
    )
    let filterAfter = Refine.after(ignoreTag: ignoreTag)

    return EventStore().today(
      filterBefore: filterBefore,
      filterAfter: filterAfter
    )
  }

  func calendars() -> [Calendar] {
    return EventStore().calendars()
  }

  func next(
    within: Int,
    ignoreAllDayEvents: Bool,
    ignorePatternTitle: String,
    ignoreTag: String
  ) -> [Event] {
    let filterBefore = Refine.before(
      ignoreAllDayEvents: ignoreAllDayEvents,
      ignorePatternTitle: ignorePatternTitle,
      ignoreCalendars: []
    )
    let filterAfter = Refine.after(
      ignoreTag: ignoreTag
    )
    let transformer = Transformers.id

    let events = EventStore().next(
      within: within,
      filterBefore: filterBefore,
      filterAfter: filterAfter
    ).map { event in
      transformer(event)
    }.sorted { $0.endsIn > $1.endsIn }

    if events.count == 0 {
      return Array(events)
    }
    // prefix crashes if sequence has no elements
    return Array(events.prefix(upTo: 1))
  }
}
