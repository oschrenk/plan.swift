import EventKit

/// Filter calendars based on various criteria
protocol CalendarFilterI {
  func accept(_ calendar: PlanCalendar?) -> Bool
}

enum CalendarFilter {
  class Accept: CalendarFilterI {
    func accept(_: PlanCalendar?) -> Bool {
      return true
    }
  }

  class Select: CalendarFilterI {
    let uuids: [String]

    init(uuids: [String]) {
      self.uuids = uuids
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
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

  class Ignore: CalendarFilterI {
    let uuids: [String]

    init(uuids: [String]) {
      self.uuids = uuids
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
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

  class SelectSources: CalendarFilterI {
    let sources: [String]

    init(sources: [String]) {
      self.sources = sources
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
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

  class IgnoreSources: CalendarFilterI {
    let sources: [String]

    init(sources: [String]) {
      self.sources = sources
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
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

  class SelectTypes: CalendarFilterI {
    let types: [EKCalendarType]

    init(types: [EKCalendarType]) {
      self.types = types
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
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

  class IgnoreTypes: CalendarFilterI {
    let types: [EKCalendarType]

    init(types: [EKCalendarType]) {
      self.types = types
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
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

  class Combined: CalendarFilterI {
    let filters: [CalendarFilterI]

    init(filters: [CalendarFilterI]) {
      self.filters = filters
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
      return filters.allSatisfy { $0.accept(calendar) }
    }
  }

  static func build(
    selectCalendars: [String] = [],
    ignoreCalendars: [String] = [],
    selectCalendarSources: [String] = [],
    ignoreCalendarSources: [String] = [],
    selectCalendarTypes: [EKCalendarType] = [],
    ignoreCalendarTypes: [EKCalendarType] = []
  ) -> CalendarFilterI {
    var filters: [CalendarFilterI] = []

    if !selectCalendars.isEmpty {
      let scf: CalendarFilterI = CalendarFilter.Select(uuids: selectCalendars)
      filters.append(scf)
      Log.write("added filter before: selectCalendars(\(selectCalendars))")
    }

    if !ignoreCalendars.isEmpty {
      let icf: CalendarFilterI = CalendarFilter.Ignore(uuids: ignoreCalendars)
      filters.append(icf)
      Log.write("added filter before: ignoreCalendars(\(ignoreCalendars))")
    }

    if !selectCalendarSources.isEmpty {
      let f: CalendarFilterI = CalendarFilter.SelectSources(sources: selectCalendarSources)
      filters.append(f)
      Log.write("added filter before: selectSources(\(selectCalendarSources))")
    }

    if !ignoreCalendarSources.isEmpty {
      let f: CalendarFilterI = CalendarFilter.IgnoreSources(sources: ignoreCalendarSources)
      filters.append(f)
      Log.write("added filter before: ignoreSources(\(ignoreCalendarSources))")
    }

    if !selectCalendarTypes.isEmpty {
      let sct: CalendarFilterI = CalendarFilter.SelectTypes(types: selectCalendarTypes)
      filters.append(sct)
      Log.write("added filter before: selectCalendarTypes(\(selectCalendarTypes))")
    }

    if !ignoreCalendarTypes.isEmpty {
      let ict: CalendarFilterI = CalendarFilter.IgnoreTypes(types: ignoreCalendarTypes)
      filters.append(ict)
      Log.write("added filter before: ignoreCalendarTypes(\(ignoreCalendarTypes))")
    }

    let filterBefore: CalendarFilterI = filters.isEmpty ?
      CalendarFilter.Accept() :
      CalendarFilter.Combined(filters: filters)

    return filterBefore
  }
}
