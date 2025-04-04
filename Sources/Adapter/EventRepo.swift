import EventKit

final class EventRepo {
  private let eventStore = EKEventStore()
  private var hooks: [Hook] = []

  let eventQueue = DispatchQueue(label: "com.oschrenk.plan")

  private func grantAccess() -> EKEventStore {
    if #available(macOS 14, *) {
      self.eventStore.requestFullAccessToEvents { granted, maybeError in
        if granted {
          self.eventStore.reset()
        } else {
          if let error = maybeError {
            print(error.localizedDescription)
          } else {
            print("Not granted, but also no error")
          }
        }
      }
    }
    return eventStore
  }

  private func fetchEkCalendars(filter: CalendarFilterI) -> [EKCalendar] {
    let eventStore = grantAccess()

    // I have no idea why this works but it seems I need to reset
    // and then refresh the eventStore, otherwise I silently get no results
    eventStore.reset()
    eventStore.refreshSourcesIfNecessary()

    return eventStore.calendars(for: EKEntityType.event).filter { calendar in
      filter.accept(calendar.asCal())
    }
  }

  func fetchCalendars(filter: CalendarFilterI) -> [PlanCalendar] {
    return fetchEkCalendars(filter: filter).map { $0.asCal() }
  }

  /// Returns a list of events
  ///
  /// The underlying EKEventStore allows building a filer based on
  /// start-date, end-date, and list of calendars.
  ///
  /// - Parameters:
  ///     - start: Minimum start date of event
  ///     - end: Maximum start date of event
  ///     - calendarFilter: A filter to select certain calendars
  ///
  /// - Returns: a list of events
  func fetchEvents(
    _ start: Date,
    _ end: Date,
    _ calendarFilter: CalendarFilterI
  ) -> [Event] {
    let eventStore = grantAccess()

    // I have no idea why this works but it seems I need to reset
    // and then refresh the EventStore, otherwise I sometimes get no ids back
    // or just partial results
    eventStore.reset()
    eventStore.refreshSourcesIfNecessary()

    let calendars = fetchEkCalendars(filter: calendarFilter)
    // an empty list means, no valid selection, but unfortunately the api for
    // eventStore.predicateForEvents treats nil and an emptyList as a means
    // to retrieve all calendars, so we short circuit
    if calendars.isEmpty {
      return []
    }

    let predicate = eventStore.predicateForEvents(
      withStart: start,
      end: end,
      calendars: calendars
    )

    return eventStore.events(matching: predicate)
      .map { event in
        event.asEvent()
      }
  }

  /// Add a new Event
  ///
  /// - Parameters:
  ///     - event: New event
  func addEvent(event: AddEvent) {
    let addEvent = event.asEKEvent(
      eventStore: eventStore,
      calendar: eventStore.defaultCalendarForNewEvents
    )

    do {
      try eventStore.save(addEvent, span: .thisEvent)
    } catch let error as NSError {
      StdErr.print("failed to save event with error : \(error)")
    }
    StdOut.print("Saved Event")
  }

  func registerForEventStoreChanges(hooks: [Hook]) {
    NotificationCenter.default.addObserver(
      forName: .EKEventStoreChanged,
      object: nil,
      queue: nil
    ) { _ in
      self.eventQueue.async {
        for hook in hooks {
          hook.trigger()
        }
      }
    }
  }

  deinit {
    NotificationCenter.default.removeObserver(
      self,
      name: .EKEventStoreChanged,
      object: nil
    )
  }
}
