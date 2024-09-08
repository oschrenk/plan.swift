import EventKit

class CalendarSelector {
  static func build(calendars: [EKCalendar], filter: (PlanCalendar) -> Bool) -> [EKCalendar] {
    calendars.filter { calendar in
      filter(calendar.asCal())
    }
  }
}
