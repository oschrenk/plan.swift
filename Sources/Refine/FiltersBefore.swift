import EventKit

class FiltersBefore {
  static func accept(_: EKEvent) -> Bool {
    true
  }

  static func selectCalendars(calendars: [String]) -> ((EKEvent) -> Bool) {
    { event in
      // if no selection, allow everything
      if calendars.isEmpty {
        return true
      }
      // if event has no valid calendar, don't show
      if event.calendar == nil {
        return false
      }

      return calendars.contains(event.calendar.calendarIdentifier.uppercased())
    }
  }

  static func ignoreCalendars(calendars: [String]) -> ((EKEvent) -> Bool) {
    { event in
      // if no selection, allow everything
      if calendars.isEmpty {
        return true
      }

      // if event has no valid calendar, don't show
      if event.calendar == nil {
        return false
      }

      return !calendars.contains(event.calendar.calendarIdentifier.uppercased())
    }
  }

  static func selectCalendarTypes(types: [EKCalendarType]) -> ((EKEvent) -> Bool) {
    { event in
      // if no selection, allow everything
      if types.isEmpty {
        return true
      }

      // if event has no valid calendar, don't show
      if event.calendar == nil {
        return false
      }

      return types.contains(event.calendar.type)
    }
  }

  static func ignoreCalendarTypes(types: [EKCalendarType]) -> ((EKEvent) -> Bool) {
    { event in
      // if no selection, allow everything
      if types.isEmpty {
        return true
      }

      // if event has no valid calendar, don't show
      if event.calendar == nil {
        return false
      }

      return !types.contains(event.calendar.type)
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
      Log.write("added filter before: ignoreAllDayEvents")
    }

    if !ignorePatternTitle.isEmpty {
      let ipt: (EKEvent) -> Bool = FiltersBefore.ignorePatternTitle(pattern: ignorePatternTitle)
      filtersBefore.append(ipt)
      Log.write("added filter before: ignorePatternTitle(\(ignorePatternTitle))")
    }

    if !selectCalendars.isEmpty {
      let sc: (EKEvent) -> Bool = FiltersBefore.selectCalendars(calendars: ignoreCalendars)
      filtersBefore.append(sc)
      Log.write("added filter before: selectCalendars(\(selectCalendars))")
    }

    if !ignoreCalendars.isEmpty {
      let ic: (EKEvent) -> Bool = FiltersBefore.ignoreCalendars(calendars: ignoreCalendars)
      filtersBefore.append(ic)
      Log.write("added filter before: ignoreCalendars(\(ignoreCalendars))")
    }

    if !selectCalendarTypes.isEmpty {
      let ic: (EKEvent) -> Bool = FiltersBefore.selectCalendarTypes(types: selectCalendarTypes)
      filtersBefore.append(ic)
      Log.write("added filter before: selectCalendarTypes(\(selectCalendarTypes))")
    }

    if !ignoreCalendarTypes.isEmpty {
      let ic: (EKEvent) -> Bool = FiltersBefore.ignoreCalendarTypes(types: ignoreCalendarTypes)
      filtersBefore.append(ic)
      Log.write("added filter before: ignoreCalendarTypes(\(ignoreCalendarTypes))")
    }

    let filterBefore = filtersBefore.count > 0 ? FiltersBefore.combined(filters: filtersBefore) : FiltersBefore.accept

    return filterBefore
  }
}
