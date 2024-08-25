class FiltersAfter {
  static func accept(_: Event) -> Bool {
    true
  }

  static func ignoreTag(tag: String) -> ((Event) -> Bool) {
    { event in
      !event.tags.contains(tag)
    }
  }

  static func combined(filters: [(Event) -> Bool]) -> ((Event) -> Bool) {
    { event in
      filters.first!(event)
    }
  }

  static func build(ignoreTag: String) -> ((Event) -> Bool) {
    var filtersAfter: [(Event) -> Bool] = []
    if !ignoreTag.isEmpty {
      let rtf: (Event) -> Bool = FiltersAfter.ignoreTag(tag: ignoreTag)
      filtersAfter.append(rtf)
      Log.write("added filter after: ignoreTag(\(ignoreTag))")
    }
    let filterAfter = filtersAfter.count > 0 ? FiltersAfter.combined(filters: filtersAfter) : FiltersAfter.accept

    return filterAfter
  }
}
