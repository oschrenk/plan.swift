import EventKit

class CalendarFilter {
  static func accept(_: PlanCalendar) -> Bool {
    true
  }

  static func select(uuids: [String]) -> ((PlanCalendar?) -> Bool) {
    { calendar in
      // if no selection, allow everything
      if uuids.isEmpty {
        return true
      }
      // if event has no valid calendar, don't show
      if calendar == nil {
        return false
      }

      return uuids.contains(calendar!.id.uppercased())
    }
  }

  static func ignore(uuids: [String]) -> ((PlanCalendar?) -> Bool) {
    { calendar in
      // if no selection, allow everything
      if uuids.isEmpty {
        return true
      }

      // if event has no valid calendar, don't show
      if calendar == nil {
        return false
      }

      return !uuids.contains(calendar!.id.uppercased())
    }
  }

  static func selectSources(sources: [String]) -> ((PlanCalendar?) -> Bool) {
    { calendar in
      // if no selection, allow everything
      if sources.isEmpty {
        return true
      }
      // if event has no valid calendar, don't show
      if calendar == nil {
        return false
      }

      return sources.contains(calendar!.source)
    }
  }

  static func ignoreSources(sources: [String]) -> ((PlanCalendar?) -> Bool) {
    { calendar in
      // if no selection, allow everything
      if sources.isEmpty {
        return true
      }

      // if event has no valid calendar, don't show
      if calendar == nil {
        return false
      }

      return !sources.contains(calendar!.source)
    }
  }

  static func selectTypes(types: [EKCalendarType]) -> ((PlanCalendar?) -> Bool) {
    { calendar in
      // if no selection, allow everything
      if types.isEmpty {
        return true
      }

      // if event has no valid calendar, don't show
      if calendar == nil {
        return false
      }

      let type: String = calendar!.type.description
      return types.map { $0.description }.contains(type)
    }
  }

  static func ignoreTypes(types: [EKCalendarType]) -> ((PlanCalendar?) -> Bool) {
    { calendar in
      // if no selection, allow everything
      if types.isEmpty {
        return true
      }

      // if no valid calendar, don't show
      if calendar == nil {
        return false
      }

      let type: String = calendar!.type.description
      return !types.map { $0.description }.contains(type)
    }
  }

  static func combined(filters: [(PlanCalendar) -> Bool]) -> ((PlanCalendar) -> Bool) {
    { event in
      filters.allSatisfy { $0(event) }
    }
  }

  static func build(
    selectCalendars: [String] = [],
    ignoreCalendars: [String] = [],
    selectCalendarSources: [String] = [],
    ignoreCalendarSources: [String] = [],
    selectCalendarTypes: [EKCalendarType] = [],
    ignoreCalendarTypes: [EKCalendarType] = []
  ) -> ((PlanCalendar) -> Bool) {
    var filters: [(PlanCalendar) -> Bool] = []

    if !selectCalendars.isEmpty {
      let scf: (PlanCalendar) -> Bool = CalendarFilter.select(uuids: selectCalendars)
      filters.append(scf)
      Log.write("added filter before: selectCalendars(\(selectCalendars))")
    }

    if !ignoreCalendars.isEmpty {
      let icf: (PlanCalendar) -> Bool = CalendarFilter.ignore(uuids: ignoreCalendars)
      filters.append(icf)
      Log.write("added filter before: ignoreCalendars(\(ignoreCalendars))")
    }

    if !selectCalendarSources.isEmpty {
      let f: (PlanCalendar) -> Bool = CalendarFilter.selectSources(sources: selectCalendarSources)
      filters.append(f)
      Log.write("added filter before: selectSources(\(selectCalendarSources))")
    }

    if !ignoreCalendarSources.isEmpty {
      let f: (PlanCalendar) -> Bool = CalendarFilter.ignoreSources(sources: ignoreCalendarSources)
      filters.append(f)
      Log.write("added filter before: ignoreSources(\(ignoreCalendarSources))")
    }

    if !selectCalendarTypes.isEmpty {
      let sct: (PlanCalendar) -> Bool = CalendarFilter.selectTypes(types: selectCalendarTypes)
      filters.append(sct)
      Log.write("added filter before: selectCalendarTypes(\(selectCalendarTypes))")
    }

    if !ignoreCalendarTypes.isEmpty {
      let ict: (PlanCalendar) -> Bool = CalendarFilter.ignoreTypes(types: ignoreCalendarTypes)
      filters.append(ict)
      Log.write("added filter before: ignoreCalendarTypes(\(ignoreCalendarTypes))")
    }

    let filterBefore = filters.isEmpty ?
      CalendarFilter.accept :
      CalendarFilter.combined(filters: filters)

    return filterBefore
  }
}
