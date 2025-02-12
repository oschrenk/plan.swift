/// Filter events based on various criteria
protocol EventFilterI {
  func accept(_ event: Event) -> Bool
}

/// Filter events based on various criteria
enum EventFilter {
  class Accept: EventFilterI {
    func accept(_: Event) -> Bool {
      return true
    }
  }

  class IgnoreAllDay: EventFilterI {
    func accept(_ event: Event) -> Bool {
      return !event.schedule.allDay
    }
  }

  class IgnorePatternTitle: EventFilterI {
    let pattern: String

    init(pattern: String) {
      self.pattern = pattern
    }

    func accept(_ event: Event) -> Bool {
      if event.title.full.range(of: pattern, options: .regularExpression) != nil {
        false
      } else {
        true
      }
    }
  }

  class MinNumAttendees: EventFilterI {
    let count: Int

    init(count: Int) {
      self.count = count
    }

    func accept(_ event: Event) -> Bool {
      return event.meeting.attendees.count >= count
    }
  }

  class MaxNumAttendees: EventFilterI {
    let count: Int

    init(count: Int) {
      self.count = count
    }

    func accept(_ event: Event) -> Bool {
      return event.meeting.attendees.count <= count
    }
  }

  class IgnoreTags: EventFilterI {
    let tags: [String]

    init(tags: [String]) {
      self.tags = tags
    }

    func accept(_ event: Event) -> Bool {
      let intersection = Set(tags).intersection(Set(event.tags))
      let hasMatchingTag = !intersection.isEmpty

      Log.write("Event \"\(event.title.full)\" has tags: \(event.tags).")
      Log.write("Ignoring \(tags). hasMatchingTag: \(hasMatchingTag)")

      return !hasMatchingTag
    }
  }

  class Combined: EventFilterI {
    let filters: [EventFilterI]

    init(filters: [EventFilterI]) {
      self.filters = filters
    }

    func accept(_ event: Event) -> Bool {
      return filters.allSatisfy { $0.accept(event) }
    }
  }

  static func build(
    ignoreAllDay: Bool,
    ignorePatternTitle: String,
    ignoreTags: [String],
    minNumAttendees: Int?,
    maxNumAttendees: Int?
  ) -> (EventFilterI) {
    var filters: [EventFilterI] = []

    if ignoreAllDay {
      let iad: EventFilterI = EventFilter.IgnoreAllDay()
      filters.append(iad)
      Log.write("added event filter: ignoreAllDay")
    }

    if !ignorePatternTitle.isEmpty {
      let ipt: EventFilterI = EventFilter.IgnorePatternTitle(pattern: ignorePatternTitle)
      filters.append(ipt)
      Log.write("added filter after: ignorePatternTitle(\(ignorePatternTitle))")
    }

    if !ignoreTags.isEmpty {
      let rtf: EventFilterI = EventFilter.IgnoreTags(tags: ignoreTags)
      filters.append(rtf)
      Log.write("added filter after: ignoreTags(\(ignoreTags))")
    }

    if minNumAttendees ?? -1 >= 0 {
      let mina: EventFilterI = EventFilter.MinNumAttendees(count: minNumAttendees!)
      filters.append(mina)
      Log.write("added filter after: minNumAttendees(\(minNumAttendees!))")
    }

    if maxNumAttendees ?? -1 >= 0 {
      let maxa: EventFilterI = EventFilter.MaxNumAttendees(count: maxNumAttendees!)
      filters.append(maxa)
      Log.write("added filter after: maxNumAttendees(\(maxNumAttendees!))")
    }

    let final: EventFilterI = filters.isEmpty ?
      EventFilter.Accept() :
      EventFilter.Combined(filters: filters)

    return final
  }
}
