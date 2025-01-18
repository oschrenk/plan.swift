/// protocol EventSelector
protocol EventSelectorI {
  func select(events: [Event]) -> [Event]
}

/// Select events based on various criteria
enum EventSelector {
  class All: EventSelectorI {
    typealias T = Event
    func select(events: [Event]) -> [Event] {
      return events
    }
  }

  class Prefix: EventSelectorI {
    let count: Int

    init(count: Int) {
      self.count = count
    }

    func select(events: [Event]) -> [Event] {
      return Array(events.prefix(count))
    }
  }
}
