import EventKit
import Foundation
import struct Foundation.Calendar

typealias FCalendar = Foundation.Calendar

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

  func today(
    filterBefore: (EKEvent) -> Bool,
    filterAfter: (Event) -> Bool
  ) -> [Event] {
    let today = FCalendar.current.startOfDay(for: Date())
    let start = FCalendar.current.date(byAdding: .day, value: 0, to: today)!
    let end = FCalendar.current.date(byAdding: .day, value: 1, to: today)!

    return fetch(start: start, end: end, filterBefore: filterBefore, filterAfter: filterAfter)
  }

  func calendars() -> [Calendar] {
    let eventStore = grantAccess()
    // FIXME: I have no idea why this works but it seems I need to reset
    // and then refresh the eventStore, otherwise I silently get no results
    eventStore.reset()
    eventStore.refreshSourcesIfNecessary()
    return eventStore.calendars(for: EKEntityType.event).map { calendar in
      calendar.asCal()
    }
  }

  func next(
    within: Int,
    filterBefore: (EKEvent) -> Bool,
    filterAfter: (Event) -> Bool
  ) -> [Event] {
    let today = Date()
    let start = FCalendar.current.date(byAdding: .day, value: 0, to: today)!
    let end = FCalendar.current.date(byAdding: .minute, value: within, to: today)!

    return Array(fetch(start: start, end: end, filterBefore: filterBefore, filterAfter: filterAfter))
  }

  private func fetch(start: Date, end: Date, filterBefore: (EKEvent) -> Bool, filterAfter: (Event) -> Bool) -> [Event] {
    let eventStore = grantAccess()

    // FIXME: I have no idea why this works but it seems I need to reset
    // and then refresh the eventStore, otherwise I sometimes get no ids back
    // or just partial results
    eventStore.reset()
    eventStore.refreshSourcesIfNecessary()

    let predicate = eventStore.predicateForEvents(
      withStart: start,
      end: end,
      calendars: nil
    )

    return eventStore.events(matching: predicate)
      .filter { event in
        filterBefore(event)
      }
      .map { event in
        event.asEvent()
      }
      .filter { event in
        filterAfter(event)
      }
  }

  func add() {
    let event = EKEvent(eventStore: eventStore)

    event.title = "Test Title"
    event.startDate = Date()
    event.endDate = Date()
    event.notes = "This is a note"
    event.calendar = eventStore.defaultCalendarForNewEvents
    do {
      try eventStore.save(event, span: .thisEvent)
    } catch let error as NSError {
      print("failed to save event with error : \(error)")
    }
    print("Saved Event")
  }
}
