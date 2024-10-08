class EventFilter {
  static func accept(_: Event) -> Bool {
    true
  }

  static func ignoreAllDay(event: Event) -> Bool {
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

  static func minNumAttendees(number: Int) -> ((Event) -> Bool) {
    { event in
      event.meeting.attendees.count >= number
    }
  }

  static func maxNumAttendees(number: Int) -> ((Event) -> Bool) {
    { event in
      event.meeting.attendees.count <= number
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
    ignoreAllDay: Bool,
    ignorePatternTitle: String,
    ignoreTags: [String],
    minNumAttendees: Int?,
    maxNumAttendees: Int?
  ) -> ((Event) -> Bool) {
    var filters: [(Event) -> Bool] = []

    if ignoreAllDay {
      let iad: (Event) -> Bool = EventFilter.ignoreAllDay
      filters.append(iad)
      Log.write("added event filter: ignoreAllDay")
    }

    if !ignorePatternTitle.isEmpty {
      let ipt: (Event) -> Bool = EventFilter.ignorePatternTitle(pattern: ignorePatternTitle)
      filters.append(ipt)
      Log.write("added filter after: ignorePatternTitle(\(ignorePatternTitle))")
    }

    if !ignoreTags.isEmpty {
      let rtf: (Event) -> Bool = EventFilter.ignoreTags(tags: ignoreTags)
      filters.append(rtf)
      Log.write("added filter after: ignoreTags(\(ignoreTags))")
    }

    if minNumAttendees ?? -1 >= 0 {
      let mina: (Event) -> Bool = EventFilter.minNumAttendees(number: minNumAttendees!)
      filters.append(mina)
      Log.write("added filter after: minNumAttendees(\(minNumAttendees!))")
    }

    if maxNumAttendees ?? -1 >= 0 {
      let maxa: (Event) -> Bool = EventFilter.maxNumAttendees(number: maxNumAttendees!)
      filters.append(maxa)
      Log.write("added filter after: maxNumAttendees(\(maxNumAttendees!))")
    }

    let final = filters.isEmpty ?
      EventFilter.accept :
      EventFilter.combined(filters: filters)

    return final
  }
}
