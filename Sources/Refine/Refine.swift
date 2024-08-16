import EventKit

class Refine {
  static func after(ignoreTag: String) -> ((Event) -> Bool) {
    var filtersAfter: [(Event) -> Bool] = []
    if !ignoreTag.isEmpty {
      let rtf: (Event) -> Bool = FiltersAfter.ignoreTag(tag: ignoreTag)
      filtersAfter.append(rtf)
      Log.write(message: "added filter after: ignoreTag(\(ignoreTag))")
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
      Log.write(message: "added filter before: ignoreAllDayEvents")
    }
    if !ignorePatternTitle.isEmpty {
      let ipt: (EKEvent) -> Bool = FiltersBefore.ignorePatternTitle(pattern: ignorePatternTitle)
      filtersBefore.append(ipt)
      Log.write(message: "added filter before: ignorePatternTitle(\(ignorePatternTitle))")
    }

    let filterBefore = filtersBefore.count > 0 ? FiltersBefore.combined(filters: filtersBefore) : FiltersBefore.accept

    return filterBefore
  }
}
