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

  /// Select the first `count` events
  class Prefix: EventSelectorI {
    let count: Int

    init(count: Int) {
      self.count = count
    }

    func select(events: [Event]) -> [Event] {
      return Array(events.prefix(count))
    }
  }

  /// Sort the events
  class Sorted: EventSelectorI {
    let comparators: [EventComparator]

    init(orders: [Order]) {
      comparators = orders.map { EventComparator(order: $0) }
    }

    func select(events: [Event]) -> [Event] {
      return comparators.reduce(events) {
        $0.sorted(using: $1)
      }
    }
  }

  class Combined: EventSelectorI {
    let selectors: [EventSelectorI]

    init(selectors: [EventSelectorI]) {
      self.selectors = selectors
    }

    func select(events: [Event]) -> [Event] {
      return selectors.reduce(events) { $1.select(events: $0) }
    }
  }
}
