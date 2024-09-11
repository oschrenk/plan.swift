import EventKit

class EventSelector {
  static func all() -> (([EKEvent]) -> [EKEvent]) {
    { events in
      events
    }
  }

  static func prefix(count: Int) -> (([EKEvent]) -> [EKEvent]) {
    { events in
      Array(events.prefix(count))
    }
  }
}
