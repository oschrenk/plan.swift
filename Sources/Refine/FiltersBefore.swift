import EventKit

class FiltersBefore {
  static func accept(_: EKEvent) -> Bool {
    true
  }

  static func ignoreCalendars(calendars: [String]) -> ((EKEvent) -> Bool) {
    { event in
      if event.calendar == nil {
        return false
      }
      let id = event.calendar.calendarIdentifier.uppercased()
      if calendars.contains(id) {
        print("yes")
        return false
      }
      return true
    }
  }

  static func ignoreAllDayEvents(event: EKEvent) -> Bool {
    !event.isAllDay
  }

  static func ignorePatternTitle(pattern: String) -> ((EKEvent) -> Bool) {
    { event in
      if event.title.range(of: pattern, options: .regularExpression) != nil {
        false
      } else {
        true
      }
    }
  }

  static func combined(filters: [(EKEvent) -> Bool]) -> ((EKEvent) -> Bool) {
    { event in
      filters.first!(event)
    }
  }
}
