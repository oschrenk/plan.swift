class FiltersAfter {
  static func accept(_: Event) -> Bool {
    true
  }

  static func ignoreTags(tags: [String]) -> ((Event) -> Bool) {
    { event in
      let intersection = Set(tags).intersection(Set(event.tags))
      let hasMatchingTag = !intersection.isEmpty
      Log.write("Event \"\(event.title.full)\" has tags: \(event.tags). We are ignoring \(tags). hasMatchingTag: \(hasMatchingTag)")
      return !hasMatchingTag
    }
  }

  static func combined(filters: [(Event) -> Bool]) -> ((Event) -> Bool) {
    { event in
      filters.first!(event)
    }
  }

  static func build(ignoreTags: [String]) -> ((Event) -> Bool) {
    var filtersAfter: [(Event) -> Bool] = []
    if !ignoreTags.isEmpty {
      let rtf: (Event) -> Bool = FiltersAfter.ignoreTags(tags: ignoreTags)
      filtersAfter.append(rtf)
      Log.write("added filter after: ignoreTags(\(ignoreTags))")
    }
    let filterAfter = filtersAfter.count > 0 ? FiltersAfter.combined(filters: filtersAfter) : FiltersAfter.accept

    return filterAfter
  }
}
