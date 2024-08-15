class Refine {
  static func build(rejectTag: String) -> ((Event) -> Bool) {
    var filtersAfter: [(Event) -> Bool] = []
    if !rejectTag.isEmpty {
      let rtf: (Event) -> Bool = FiltersAfter.rejectTag(tag: rejectTag)
      filtersAfter.append(rtf)
    }
    let filterAfter = filtersAfter.count > 0 ? FiltersAfter.combined(filters: filtersAfter) : FiltersAfter.accept

    return filterAfter
  }
}
