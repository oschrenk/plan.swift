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

  class Sorted: EventSelectorI {
    let order: Order

    init(order: Order) {
      self.order = order
    }

    func select(events: [Event]) -> [Event] {
      return events.sorted(using: EventComparator(order: order))
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
