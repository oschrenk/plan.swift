import EventKit

class CalendarSelector {
  static func build(calendars: [EKCalendar], filter: CalendarFilterI) -> [EKCalendar] {
    calendars.filter { calendar in
      filter.accept(calendar.asCal())
    }
  }
}
