/// Filter events based on various criteria
protocol EventFilterI: CustomStringConvertible {
  func accept(_ event: Event) -> Bool
}

/// Filter events based on various criteria
enum EventFilter {
  class Accept: EventFilterI {
    func accept(_: Event) -> Bool {
      true
    }

    var description: String {
      "EventFilter.Accept()"
    }
  }

  class IgnoreAllDay: EventFilterI {
    func accept(_ event: Event) -> Bool {
      !event.schedule.allDay
    }

    var description: String {
      "EventFilter.IgnoreAllDay()"
    }
  }

  class SelectAllDay: EventFilterI {
    func accept(_ event: Event) -> Bool {
      event.schedule.allDay
    }

    var description: String {
      "EventFilter.SelectAllDay()"
    }
  }

  class IgnoreTitle: EventFilterI {
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
      "EventFilter.IgnoreTitle(\(pattern))"
    }
  }

  class SelectTitle: EventFilterI {
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
      "EventFilter.SelectTitle(\(pattern))"
    }
  }

  class MinNumAttendees: EventFilterI {
    let count: Int

    init(count: Int) {
      self.count = count
    }

    func accept(_ event: Event) -> Bool {
      event.meeting.attendees.count >= count
    }

    var description: String {
      "EventFilter.MinNumAttendees(\(count))"
    }
  }

  class MaxNumAttendees: EventFilterI {
    let count: Int

    init(count: Int) {
      self.count = count
    }

    func accept(_ event: Event) -> Bool {
      event.meeting.attendees.count <= count
    }

    var description: String {
      "EventFilter.MaxNumAttendees(\(count))"
    }
  }

  class MinDuration: EventFilterI {
    let minutes: Int

    init(minutes: Int) {
      self.minutes = minutes
    }

    func accept(_ event: Event) -> Bool {
      event.schedule.duration >= minutes
    }

    var description: String {
      "EventFilter.MinDuration(\(minutes))"
    }
  }

  class MaxDuration: EventFilterI {
    let minutes: Int

    init(minutes: Int) {
      self.minutes = minutes
    }

    func accept(_ event: Event) -> Bool {
      event.schedule.duration <= minutes
    }

    var description: String {
      "EventFilter.MaxDuration(\(minutes))"
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
      return !hasMatchingTag
    }

    var description: String {
      "EventFilter.IgnoreTags(\(tags))"
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
      "EventFilter.SelectTags(\(tags))"
    }
  }

  class IgnoreServices: EventFilterI {
    let services: [String]

    init(services: [String]) {
      self.services = services
    }

    func accept(_ event: Event) -> Bool {
      let intersection = Set(services).intersection(Set(event.services.keys))
      let hasMatchingService = !intersection.isEmpty
      return !hasMatchingService
    }

    var description: String {
      "EventFilter.IgnoreServices(\(services))"
    }
  }

  class SelectServices: EventFilterI {
    let services: [String]

    init(services: [String]) {
      self.services = services
    }

    func accept(_ event: Event) -> Bool {
      let intersection = Set(services).intersection(Set(event.services.keys))
      return !intersection.isEmpty
    }

    var description: String {
      "EventFilter.SelectServices(\(services))"
    }
  }

  class Combined: EventFilterI {
    let filters: [EventFilterI]

    init(filters: [EventFilterI]) {
      self.filters = filters
    }

    func accept(_ event: Event) -> Bool {
      filters.allSatisfy { $0.accept(event) }
    }

    var description: String {
      "EventFilter.Combined(\(filters))"
    }
  }

  // ignoring cyclomatic_complexity, since they are
  // required checks and just add filters
  // swiftlint:disable:next cyclomatic_complexity
  static func build(
    opts: EventOptions
  ) -> (EventFilterI) {
    var filters: [EventFilterI] = []

    func add(_ f: EventFilterI) {
      filters.append(f)
      Log.write("added \(f)")
    }

    if opts.ignoreAllDayEvents {
      add(EventFilter.IgnoreAllDay())
    }

    if opts.selectAllDayEvents {
      add(EventFilter.SelectAllDay())
    }

    if !opts.ignoreTitle.isEmpty {
      add(EventFilter.IgnoreTitle(pattern: opts.ignoreTitle))
    }

    if !opts.selectTitle.isEmpty {
      add(EventFilter.SelectTitle(pattern: opts.selectTitle))
    }

    if !opts.ignoreTags.isEmpty {
      add(EventFilter.IgnoreTags(tags: opts.ignoreTags))
    }

    if !opts.selectTags.isEmpty {
      add(EventFilter.SelectTags(tags: opts.selectTags))
    }

    if !opts.ignoreServices.isEmpty {
      add(EventFilter.IgnoreServices(services: opts.ignoreServices))
    }

    if !opts.selectServices.isEmpty {
      add(EventFilter.SelectServices(services: opts.selectServices))
    }

    if opts.minNumAttendees ?? -1 >= 0 {
      add(EventFilter.MinNumAttendees(count: opts.minNumAttendees!))
    }

    if opts.maxNumAttendees ?? -1 >= 0 {
      add(EventFilter.MaxNumAttendees(count: opts.maxNumAttendees!))
    }

    if opts.minDuration ?? -1 >= 0 {
      add(EventFilter.MinDuration(minutes: opts.minDuration!))
    }

    if opts.maxDuration ?? -1 >= 0 {
      add(EventFilter.MaxDuration(minutes: opts.maxDuration!))
    }

    let final: EventFilterI = filters.isEmpty ?
      EventFilter.Accept() :
      EventFilter.Combined(filters: filters)

    return final
  }
}
