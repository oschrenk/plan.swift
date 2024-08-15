import EventKit

class Refine {
  static func after(rejectTag: String) -> ((Event) -> Bool) {
    var filtersAfter: [(Event) -> Bool] = []
    if !rejectTag.isEmpty {
      let rtf: (Event) -> Bool = FiltersAfter.rejectTag(tag: rejectTag)
      filtersAfter.append(rtf)
    }
    let filterAfter = filtersAfter.count > 0 ? FiltersAfter.combined(filters: filtersAfter) : FiltersAfter.accept

    return filterAfter
  }

  static func before(
    ignoreAllDayEvents: Bool,
    ignorePatternTitle: String
  ) -> ((EKEvent) -> Bool) {
    var filtersBefore: [(EKEvent) -> Bool] = []
    if ignoreAllDayEvents {
      let iade: (EKEvent) -> Bool = FiltersBefore.ignoreAllDayEvents
      filtersBefore.append(iade)
    }
    if !ignorePatternTitle.isEmpty {
      let ipt: (EKEvent) -> Bool = FiltersBefore.ignorePatternTitle(pattern: ignorePatternTitle)
      filtersBefore.append(ipt)
    }

    let filterBefore = filtersBefore.count > 0 ? FiltersBefore.combined(filters: filtersBefore) : FiltersBefore.accept

    return filterBefore
  }
}
