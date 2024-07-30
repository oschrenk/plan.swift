import EventKit
import Foundation

struct Plan {
  let store = EventStore()

  func today() -> [Event] {
    EventStore().today()
  }

  func calendars() -> [Cal] {
    return EventStore().calendars()
  }

  func next(
    within: Int,
    ignoreAllDayEvents _: Bool,
    ignorePatternTitle: String
  ) -> [Event] {
    // TODO: make this better
    let iade: (EKEvent) -> Bool = Filters.ignoreAllDayEvents
    let ipt: (EKEvent) -> Bool = Filters.ignorePatternTitle(pattern: ignorePatternTitle)
    var f: [(EKEvent) -> Bool] = []
    f.append(iade)
    f.append(ipt)

    let transformer = Transformers.id

    let events = EventStore().next(
      within: within,
      filter: Filters.combined(filters: f)
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
