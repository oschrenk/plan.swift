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

  class SelectIds: CalendarFilterI {
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

  class IgnoreIds: CalendarFilterI {
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

  class SelectLabels: CalendarFilterI {
    let labels: [String]

    init(labels: [String]) {
      self.labels = labels
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
      // if no selection, allow everything
      if labels.isEmpty {
        return true
      }
      // if event has no valid calendar, don't show
      if calendar == nil {
        return false
      }

      return labels.contains(calendar!.label)
    }
  }

  class IgnoreLabels: CalendarFilterI {
    let labels: [String]

    init(labels: [String]) {
      self.labels = labels
    }

    func accept(_ calendar: PlanCalendar?) -> Bool {
      // if no selection, allow everything
      if labels.isEmpty {
        return true
      }

      // if event has no valid calendar, don't show
      if calendar == nil {
        return false
      }

      return !labels.contains(calendar!.source)
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
    selectCalendarIds: [String] = [],
    ignoreCalendarIds: [String] = [],
    selectCalendarSources: [String] = [],
    ignoreCalendarSources: [String] = [],
    selectCalendarTypes: [EKCalendarType] = [],
    ignoreCalendarTypes: [EKCalendarType] = []
  ) -> CalendarFilterI {
    var filters: [CalendarFilterI] = []

    if !selectCalendarIds.isEmpty {
      let f: CalendarFilterI = CalendarFilter.SelectIds(uuids: selectCalendarIds)
      filters.append(f)
      Log.write("added filter before: selectCalendars(\(selectCalendarIds))")
    }

    if !ignoreCalendarIds.isEmpty {
      let f: CalendarFilterI = CalendarFilter.IgnoreIds(uuids: ignoreCalendarIds)
      filters.append(f)
      Log.write("added filter before: ignoreCalendars(\(ignoreCalendarIds))")
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
      let f: CalendarFilterI = CalendarFilter.SelectTypes(types: selectCalendarTypes)
      filters.append(f)
      Log.write("added filter before: selectCalendarTypes(\(selectCalendarTypes))")
    }

    if !ignoreCalendarTypes.isEmpty {
      let f: CalendarFilterI = CalendarFilter.IgnoreTypes(types: ignoreCalendarTypes)
      filters.append(f)
      Log.write("added filter before: ignoreCalendarTypes(\(ignoreCalendarTypes))")
    }

    return filters.isEmpty ?
      CalendarFilter.Accept() :
      CalendarFilter.Combined(filters: filters)
  }
}
