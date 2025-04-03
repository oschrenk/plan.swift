/// Filter events based on various criteria
protocol EventFilterI: CustomStringConvertible {
  func accept(_ event: Event) -> Bool
}

/// Filter events based on various criteria
enum EventFilter {
  class Accept: EventFilterI {
    func accept(_: Event) -> Bool {
      return true
    }

    var description: String {
      return "EventFilter.Accept()"
    }
  }

  class IgnoreAllDay: EventFilterI {
    func accept(_ event: Event) -> Bool {
      return !event.schedule.allDay
    }

    var description: String {
      return "EventFilter.IgnoreAllDay()"
    }
  }

  class SelectAllDay: EventFilterI {
    func accept(_ event: Event) -> Bool {
      return event.schedule.allDay
    }

    var description: String {
      return "EventFilter.SelectAllDay()"
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

    var description: String {
      return "EventFilter.IgnorePatternTitle(\(pattern))"
    }
  }

  class SelectPatternTitle: EventFilterI {
    let pattern: String

    init(pattern: String) {
      self.pattern = pattern
    }

    func accept(_ event: Event) -> Bool {
      if event.title.full.range(of: pattern, options: .regularExpression) != nil {
        true
      } else {
        false
      }
    }

    var description: String {
      return "EventFilter.SelectPatternTitle(\(pattern))"
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

    var description: String {
      return "EventFilter.MinNumAttendees(\(count))"
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

    var description: String {
      return "EventFilter.MaxNumAttendees(\(count))"
    }
  }

  class MinDuration: EventFilterI {
    let minutes: Int

    init(minutes: Int) {
      self.minutes = minutes
    }

    func accept(_ event: Event) -> Bool {
      return event.schedule.duration >= minutes
    }

    var description: String {
      return "EventFilter.MinDuration(\(minutes))"
    }
  }

  class MaxDuration: EventFilterI {
    let minutes: Int

    init(minutes: Int) {
      self.minutes = minutes
    }

    func accept(_ event: Event) -> Bool {
      return event.schedule.duration <= minutes
    }

    var description: String {
      return "EventFilter.MaxDuration(\(minutes))"
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

    var description: String {
      return "EventFilter.IgnoreTags(\(tags))"
    }
  }

  class SelectTags: EventFilterI {
    let tags: [String]

    init(tags: [String]) {
      self.tags = tags
    }

    func accept(_ event: Event) -> Bool {
      let intersection = Set(tags).intersection(Set(event.tags))
      let hasMatchingTag = !intersection.isEmpty

      Log.write("Event \"\(event.title.full)\" has tags: \(event.tags).")
      Log.write("Selecting \(tags). hasMatchingTag: \(hasMatchingTag)")

      return hasMatchingTag
    }

    var description: String {
      return "EventFilter.SelectTags(\(tags))"
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

    var description: String {
      return "EventFilter.Combined(\(filters))"
    }
  }

  // swiftlint:disable:next function_body_length
  static func build(
    opts: EventOptions
  ) -> (EventFilterI) {
    var filters: [EventFilterI] = []

    if opts.ignoreAllDayEvents {
      let f: EventFilterI = EventFilter.IgnoreAllDay()
      filters.append(f)
      Log.write("added \(f)")
    }

    if opts.selectAllDayEvents {
      let f: EventFilterI = EventFilter.SelectAllDay()
      filters.append(f)
      Log.write("added \(f)")
    }

    if !opts.ignorePatternTitle.isEmpty {
      let f: EventFilterI = EventFilter.IgnorePatternTitle(pattern: opts.ignorePatternTitle)
      filters.append(f)
      Log.write("added \(f)")
    }

    if !opts.selectPatternTitle.isEmpty {
      let f: EventFilterI = EventFilter.SelectPatternTitle(pattern: opts.selectPatternTitle)
      filters.append(f)
      Log.write("added \(f)")
    }

    if !opts.ignoreTags.isEmpty {
      let f: EventFilterI = EventFilter.IgnoreTags(tags: opts.ignoreTags)
      filters.append(f)
      Log.write("added \(f)")
    }

    if !opts.selectTags.isEmpty {
      let f: EventFilterI = EventFilter.SelectTags(tags: opts.selectTags)
      filters.append(f)
      Log.write("added \(f)")
    }

    if opts.minNumAttendees ?? -1 >= 0 {
      let f: EventFilterI = EventFilter.MinNumAttendees(count: opts.minNumAttendees!)
      filters.append(f)
      Log.write("added \(f)")
    }

    if opts.maxNumAttendees ?? -1 >= 0 {
      let f: EventFilterI = EventFilter.MaxNumAttendees(count: opts.maxNumAttendees!)
      filters.append(f)
      Log.write("added \(f)")
    }

    if opts.minDuration ?? -1 >= 0 {
      let f: EventFilterI = EventFilter.MinDuration(minutes: opts.minDuration!)
      filters.append(f)
      Log.write("added \(f)")
    }

    if opts.maxDuration ?? -1 >= 0 {
      let f: EventFilterI = EventFilter.MaxDuration(minutes: opts.maxDuration!)
      filters.append(f)
      Log.write("added \(f)")
    }

    let final: EventFilterI = filters.isEmpty ?
      EventFilter.Accept() :
      EventFilter.Combined(filters: filters)

    return final
  }
}
