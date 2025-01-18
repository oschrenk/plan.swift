/// Select events based on various criteria
class EventSelector {
  static func all() -> (([Event]) -> [Event]) {
    { events in
      events
    }
  }

  static func prefix(count: Int) -> (([Event]) -> [Event]) {
    { events in
      Array(events.prefix(count))
    }
  }
}
