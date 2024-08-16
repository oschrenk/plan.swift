import EventKit
import Foundation

struct AddEvent {
  let title: String
  let startsAt: Date
  let endsAt: Date
  let notes: String
}

extension AddEvent {
  func asEKEvent(eventStore: EKEventStore, calendar: EKCalendar?) -> EKEvent {
    let event = EKEvent(eventStore: eventStore)

    event.title = title
    event.startDate = startsAt
    event.endDate = endsAt
    event.notes = notes
    event.calendar = calendar

    return event
  }
}
