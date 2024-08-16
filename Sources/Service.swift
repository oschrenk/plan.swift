import EventKit
import Foundation

struct Service {
  let store = EventStore()

  func today(
    rejectTag: String
  ) -> [Event] {
    let filterAfter = Refine.after(rejectTag: rejectTag)

    return EventStore().today(
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
    rejectTag: String
  ) -> [Event] {
    let filterBefore = Refine.before(
      ignoreAllDayEvents: ignoreAllDayEvents,
      ignorePatternTitle: ignorePatternTitle
    )
    let filterAfter = Refine.after(
      rejectTag: rejectTag
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