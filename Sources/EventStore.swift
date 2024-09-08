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

  func calendars() -> [Calendar] {
    return fetchCalendars().map { calendar in
      calendar.asCal()
    }
  }

  func fetch(
    start: Date,
    end: Date,
    selectCalendars: [String]?,
    filterBefore: (EKEvent) -> Bool,
    eventFilter: (Event) -> Bool
  ) -> [Event] {
    let eventStore = grantAccess()

    // I have no idea why this works but it seems I need to reset
    // and then refresh the EventStore, otherwise I sometimes get no ids back
    // or just partial results
    eventStore.reset()
    eventStore.refreshSourcesIfNecessary()

    var calendars: [EKCalendar]?
    if selectCalendars != nil, selectCalendars!.count > 0 {
      calendars = fetchCalendars().filter { cal in
        selectCalendars!.contains(cal.calendarIdentifier)
      }
    } else {
      calendars = nil
    }

    // unfortunately the eventstore API is limited
    // calling it with an empty Array of calendars is the same
    // as calling it with nil, although it is semantically different
    // so we return an empty array ourselves and short circuit the logic
    if calendars == nil, selectCalendars != nil, selectCalendars!.count > 0 {
      return Array()
    }

    let predicate = eventStore.predicateForEvents(
      withStart: start,
      end: end,
      calendars: calendars
    )

    return eventStore.events(matching: predicate)
      .filter { event in
        filterBefore(event)
      }
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
