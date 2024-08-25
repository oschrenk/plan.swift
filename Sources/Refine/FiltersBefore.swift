import EventKit

class FiltersBefore {
  static func accept(_: EKEvent) -> Bool {
    true
  }

  static func selectCalendars(calendars: [String]) -> ((EKEvent) -> Bool) {
    { event in
      if event.calendar == nil {
        return false
      }
      let id = event.calendar.calendarIdentifier.uppercased()
      if calendars.contains(id) {
        return true
      }
      return false
    }
  }

  static func ignoreCalendars(calendars: [String]) -> ((EKEvent) -> Bool) {
    { event in
      if event.calendar == nil {
        return false
      }
      let id = event.calendar.calendarIdentifier.uppercased()
      if calendars.contains(id) {
        return false
      }
      return true
    }
  }

  static func selectCalendarTypes(types: [EKCalendarType]) -> ((EKEvent) -> Bool) {
    { event in
      if event.calendar == nil {
        return false
      }
      let id = event.calendar.type
      if types.contains(id) {
        return true
      }
      return false
    }
  }

  static func ignoreCalendarTypes(types: [EKCalendarType]) -> ((EKEvent) -> Bool) {
    { event in
      if event.calendar == nil {
        return false
      }
      let id = event.calendar.type
      if types.contains(id) {
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

  static func build(
    ignoreAllDayEvents: Bool,
    ignorePatternTitle: String,
    selectCalendars: [String] = [],
    ignoreCalendars: [String] = [],
    selectCalendarTypes: [EKCalendarType] = [],
    ignoreCalendarTypes: [EKCalendarType] = []
  ) -> ((EKEvent) -> Bool) {
    var filtersBefore: [(EKEvent) -> Bool] = []

    if ignoreAllDayEvents {
      let iade: (EKEvent) -> Bool = FiltersBefore.ignoreAllDayEvents
      filtersBefore.append(iade)
      Log.write(message: "added filter before: ignoreAllDayEvents")
    }

    if !ignorePatternTitle.isEmpty {
      let ipt: (EKEvent) -> Bool = FiltersBefore.ignorePatternTitle(pattern: ignorePatternTitle)
      filtersBefore.append(ipt)
      Log.write(message: "added filter before: ignorePatternTitle(\(ignorePatternTitle))")
    }

    if !selectCalendars.isEmpty {
      let sc: (EKEvent) -> Bool = FiltersBefore.selectCalendars(calendars: ignoreCalendars)
      filtersBefore.append(sc)
      Log.write(message: "added filter before: selectCalendars(\(selectCalendars))")
    }

    if !ignoreCalendars.isEmpty {
      let ic: (EKEvent) -> Bool = FiltersBefore.ignoreCalendars(calendars: ignoreCalendars)
      filtersBefore.append(ic)
      Log.write(message: "added filter before: ignoreCalendars(\(ignoreCalendars))")
    }

    if !selectCalendarTypes.isEmpty {
      let ic: (EKEvent) -> Bool = FiltersBefore.selectCalendarTypes(types: selectCalendarTypes)
      filtersBefore.append(ic)
      Log.write(message: "added filter before: selectCalendarTypes(\(selectCalendarTypes))")
    }

    if !ignoreCalendarTypes.isEmpty {
      let ic: (EKEvent) -> Bool = FiltersBefore.ignoreCalendarTypes(types: ignoreCalendarTypes)
      filtersBefore.append(ic)
      Log.write(message: "added filter before: ignoreCalendarTypes(\(ignoreCalendarTypes))")
    }

    let filterBefore = filtersBefore.count > 0 ? FiltersBefore.combined(filters: filtersBefore) : FiltersBefore.accept

    return filterBefore
  }
}
