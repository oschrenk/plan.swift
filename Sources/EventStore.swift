import EventKit

struct EventStore {
  let eventStore = EKEventStore()

  private func grantAccess() -> EKEventStore {
    if #available(macOS 14, *) {
      self.eventStore.requestFullAccessToEvents { granted, maybeError in
        if granted {
          eventStore.reset()
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

  private func fetchCalendars() -> [EKCalendar] {
    let eventStore = grantAccess()

    // I have no idea why this works but it seems I need to reset
    // and then refresh the eventStore, otherwise I silently get no results
    eventStore.reset()
    eventStore.refreshSourcesIfNecessary()

    return eventStore.calendars(for: EKEntityType.event)
  }

  /// Returns a list of calendars
  ///
  /// - Parameters:
  ///     - filter: A filter to select certain calendars
  func calendars(filter: CalendarFilterI) -> [PlanCalendar] {
    return CalendarSelector.build(
      calendars: fetchCalendars(),
      filter: filter
    ).map { $0.asCal() }
  }

  /// Returns a list of events
  ///
  /// - Parameters:
  ///     - start: Minimum start date of event
  ///     - end: Maximum start date of event
  ///     - calendarFilter: A filter to select certain calendars
  ///     - eventFilter: A filter to select certain events
  ///
  /// - Returns: a list of events
  func fetch(
    start: Date,
    end: Date,
    calendarFilter: CalendarFilterI,
    eventFilter: EventFilterI
  ) -> [Event] {
    let eventStore = grantAccess()

    // I have no idea why this works but it seems I need to reset
    // and then refresh the EventStore, otherwise I sometimes get no ids back
    // or just partial results
    eventStore.reset()
    eventStore.refreshSourcesIfNecessary()

    let calendars = CalendarSelector.build(
      calendars: fetchCalendars(),
      filter: calendarFilter
    )

    let predicate = eventStore.predicateForEvents(
      withStart: start,
      end: end,
      calendars: calendars
    )

    return eventStore.events(matching: predicate)
      .map { event in
        event.asEvent()
      }
      .filter { event in
        eventFilter.accept(event)
      }
  }

  func add(addEvent: AddEvent) {
    let event = addEvent.asEKEvent(
      eventStore: eventStore,
      calendar: eventStore.defaultCalendarForNewEvents
    )

    do {
      try eventStore.save(event, span: .thisEvent)
    } catch let error as NSError {
      StdErr.print("failed to save event with error : \(error)")
    }
    StdOut.print("Saved Event")
  }
}
