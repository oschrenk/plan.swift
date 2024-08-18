import EventKit
import Foundation

struct AddEvent {
  let title: String
  let startsAt: Date
  let endsAt: Date
  let tag: String?
}

extension AddEvent {
  func asEKEvent(eventStore: EKEventStore, calendar: EKCalendar?) -> EKEvent {
    let event = EKEvent(eventStore: eventStore)

    event.title = title
    event.startDate = startsAt
    event.endDate = endsAt
    event.calendar = calendar

    return event
  }
}
