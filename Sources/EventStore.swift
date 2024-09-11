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

  func calendars() -> [PlanCalendar] {
    return fetchCalendars().map { calendar in
      calendar.asCal()
    }
  }

  /// Returns a list of events
  ///
  /// - Parameters:
  ///     - start: Minimum start date of event
  ///     - end: Maximum start date of event
  ///     - calendarFilter: A filter to select certain calendars
  ///     - eventFilter: A filter to select certain events
  ///     - eventSelector: Manipulate array of events after fetching and filtering; e.g. for sorting
  ///
  /// - Returns: a list of events
  func fetch(
    start: Date,
    end: Date,
    calendarFilter: (PlanCalendar) -> Bool,
    eventFilter: (Event) -> Bool,
    eventSelector: ([EKEvent]) -> [EKEvent]
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

    return eventSelector(eventStore.events(matching: predicate))
      .map { event in
        event.asEvent()
      }
      .filter { event in
        eventFilter(event)
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
