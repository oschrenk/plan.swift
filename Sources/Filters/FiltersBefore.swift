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

  static func combined(filters: [(EKEvent) -> Bool]) -> ((EKEvent) -> Bool) {
    { event in
      filters.allSatisfy { $0(event) }
    }
  }

  static func build(
    selectCalendars: [String] = [],
    ignoreCalendars: [String] = [],
    selectCalendarTypes: [EKCalendarType] = [],
    ignoreCalendarTypes: [EKCalendarType] = []
  ) -> ((EKEvent) -> Bool) {
    var filtersBefore: [(EKEvent) -> Bool] = []

    if !selectCalendars.isEmpty {
      let scf: (EKEvent) -> Bool = FiltersBefore.selectCalendars(calendars: selectCalendars)
      filtersBefore.append(scf)
      Log.write("added filter before: selectCalendars(\(selectCalendars))")
    }

    if !ignoreCalendars.isEmpty {
      let icf: (EKEvent) -> Bool = FiltersBefore.ignoreCalendars(calendars: ignoreCalendars)
      filtersBefore.append(icf)
      Log.write("added filter before: ignoreCalendars(\(ignoreCalendars))")
    }

    if !selectCalendarTypes.isEmpty {
      let sctf: (EKEvent) -> Bool = FiltersBefore.selectCalendarTypes(types: selectCalendarTypes)
      filtersBefore.append(sctf)
      Log.write("added filter before: selectCalendarTypes(\(selectCalendarTypes))")
    }

    if !ignoreCalendarTypes.isEmpty {
      let ictf: (EKEvent) -> Bool = FiltersBefore.ignoreCalendarTypes(types: ignoreCalendarTypes)
      filtersBefore.append(ictf)
      Log.write("added filter before: ignoreCalendarTypes(\(ignoreCalendarTypes))")
    }

    let filterBefore = filtersBefore.isEmpty ?
      FiltersBefore.accept :
      FiltersBefore.combined(filters: filtersBefore)

    return filterBefore
  }
}
