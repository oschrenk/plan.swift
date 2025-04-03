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

  class SelectAllDay: EventFilterI {
    func accept(_ event: Event) -> Bool {
      return event.schedule.allDay
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

  class MinDuration: EventFilterI {
    let minutes: Int

    init(minutes: Int) {
      self.minutes = minutes
    }

    func accept(_ event: Event) -> Bool {
      return event.schedule.duration >= minutes
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

  // swiftlint:disable:next function_body_length
  static func build(
    opts: EventOptions
  ) -> (EventFilterI) {
    var filters: [EventFilterI] = []

    if opts.ignoreAllDayEvents {
      let iad: EventFilterI = EventFilter.IgnoreAllDay()
      filters.append(iad)
      Log.write("added event filter: ignoreAllDay")
    }

    if opts.selectAllDayEvents {
      let sad: EventFilterI = EventFilter.SelectAllDay()
      filters.append(sad)
      Log.write("added event filter: selectAllDay")
    }

    if !opts.ignorePatternTitle.isEmpty {
      let ipt: EventFilterI = EventFilter.IgnorePatternTitle(pattern: opts.ignorePatternTitle)
      filters.append(ipt)
      Log.write("added filter after: ignorePatternTitle(\(opts.ignorePatternTitle))")
    }

    if !opts.selectPatternTitle.isEmpty {
      let spt: EventFilterI = EventFilter.SelectPatternTitle(pattern: opts.selectPatternTitle)
      filters.append(spt)
      Log.write("added filter after: selectPatternTitle(\(opts.selectPatternTitle))")
    }

    if !opts.ignoreTags.isEmpty {
      let rtf: EventFilterI = EventFilter.IgnoreTags(tags: opts.ignoreTags)
      filters.append(rtf)
      Log.write("added filter after: ignoreTags(\(opts.ignoreTags))")
    }

    if !opts.selectTags.isEmpty {
      let stf: EventFilterI = EventFilter.SelectTags(tags: opts.selectTags)
      filters.append(stf)
      Log.write("added filter after: selectTags(\(opts.selectTags))")
    }

    if opts.minNumAttendees ?? -1 >= 0 {
      let mina: EventFilterI = EventFilter.MinNumAttendees(count: opts.minNumAttendees!)
      filters.append(mina)
      Log.write("added filter after: minNumAttendees(\(opts.minNumAttendees!))")
    }

    if opts.maxNumAttendees ?? -1 >= 0 {
      let maxa: EventFilterI = EventFilter.MaxNumAttendees(count: opts.maxNumAttendees!)
      filters.append(maxa)
      Log.write("added filter after: maxNumAttendees(\(opts.maxNumAttendees!))")
    }

    if opts.minDuration ?? -1 >= 0 {
      let mind: EventFilterI = EventFilter.MinDuration(minutes: opts.minDuration!)
      filters.append(mind)
      Log.write("added filter after: minDuration(\(opts.minDuration!))")
    }

    if opts.maxDuration ?? -1 >= 0 {
      let maxd: EventFilterI = EventFilter.MaxDuration(minutes: opts.maxDuration!)
      filters.append(maxd)
      Log.write("added filter after: maxDuration(\(opts.maxDuration!))")
    }

    let final: EventFilterI = filters.isEmpty ?
      EventFilter.Accept() :
      EventFilter.Combined(filters: filters)

    return final
  }
}
