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
}
