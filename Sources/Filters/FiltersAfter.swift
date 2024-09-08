class FiltersAfter {
  static func accept(_: Event) -> Bool {
    true
  }

  static func ignoreAllDayEvents(event: Event) -> Bool {
    !event.schedule.allDay
  }

  static func ignorePatternTitle(pattern: String) -> ((Event) -> Bool) {
    { event in
      if event.title.full.range(of: pattern, options: .regularExpression) != nil {
        false
      } else {
        true
      }
    }
  }

  static func ignoreTags(tags: [String]) -> ((Event) -> Bool) {
    { event in
      let intersection = Set(tags).intersection(Set(event.tags))
      let hasMatchingTag = !intersection.isEmpty

      Log.write("Event \"\(event.title.full)\" has tags: \(event.tags).")
      Log.write("Ignoring \(tags). hasMatchingTag: \(hasMatchingTag)")

      return !hasMatchingTag
    }
  }

  static func combined(filters: [(Event) -> Bool]) -> ((Event) -> Bool) {
    { event in
      filters.first!(event)
    }
  }

  static func build(
    ignoreAllDayEvents: Bool,
    ignorePatternTitle: String,
    ignoreTags: [String]
  ) -> ((Event) -> Bool) {
    var filtersAfter: [(Event) -> Bool] = []

    if ignoreAllDayEvents {
      let iade: (Event) -> Bool = FiltersAfter.ignoreAllDayEvents
      filtersAfter.append(iade)
      Log.write("added filter after: ignoreAllDayEvents")
    }

    if !ignorePatternTitle.isEmpty {
      let ipt: (Event) -> Bool = FiltersAfter.ignorePatternTitle(pattern: ignorePatternTitle)
      filtersAfter.append(ipt)
      Log.write("added filter after: ignorePatternTitle(\(ignorePatternTitle))")
    }

    if !ignoreTags.isEmpty {
      let rtf: (Event) -> Bool = FiltersAfter.ignoreTags(tags: ignoreTags)
      filtersAfter.append(rtf)
      Log.write("added filter after: ignoreTags(\(ignoreTags))")
    }

    let filterAfter = filtersAfter.isEmpty ?
      FiltersAfter.accept :
      FiltersAfter.combined(filters: filtersAfter)

    return filterAfter
  }
}
