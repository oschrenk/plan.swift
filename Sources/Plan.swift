import EventKit
import Foundation

struct Plan {
  let store = EventStore()

  func today(
    rejectTag: String
  ) -> [Event] {
    let filterAfter = Refine.build(rejectTag: rejectTag)

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
    var filtersBefore: [(EKEvent) -> Bool] = []
    if ignoreAllDayEvents {
      let iade: (EKEvent) -> Bool = FiltersBefore.ignoreAllDayEvents
      filtersBefore.append(iade)
    }
    if !ignorePatternTitle.isEmpty {
      let ipt: (EKEvent) -> Bool = FiltersBefore.ignorePatternTitle(pattern: ignorePatternTitle)
      filtersBefore.append(ipt)
    }

    var filtersAfter: [(Event) -> Bool] = []
    if !rejectTag.isEmpty {
      let rtf: (Event) -> Bool = FiltersAfter.rejectTag(tag: rejectTag)
      filtersAfter.append(rtf)
    }

    let filterBefore = filtersBefore.count > 0 ? FiltersBefore.combined(filters: filtersBefore) : FiltersBefore.accept

    let filterAfter = filtersAfter.count > 0 ? FiltersAfter.combined(filters: filtersAfter) : FiltersAfter.accept

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
