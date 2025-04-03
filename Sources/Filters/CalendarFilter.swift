import EventKit

/// Filter calendars based on various criteria
protocol CalendarFilterI: CustomStringConvertible {
  func accept(_ calendar: PlanCalendar?) -> Bool
}

enum CalendarFilter {
  class Accept: CalendarFilterI {
    func accept(_: PlanCalendar?) -> Bool {
      return true
    }

    var description: String {
      return "CalendarFilter.Accept()"
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

    var description: String {
      return "CalendarFilter.SelectIds(\(uuids))"
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

    var description: String {
      return "CalendarFilter.IgnoreIds(\(uuids))"
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

    var description: String {
      return "CalendarFilter.SelectLabels(\(labels))"
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

    var description: String {
      return "CalendarFilter.IgnoreLabels(\(labels))"
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

    var description: String {
      return "CalendarFilter.SelectSources(\(sources))"
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

    var description: String {
      return "CalendarFilter.IgnoreSources(\(sources))"
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

    var description: String {
      return "CalendarFilter.SelectTypes(\(types))"
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

    var description: String {
      return "CalendarFilter.IgnoreTypes(\(types))"
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

    var description: String {
      return "CalendarFilter.Combined(\(filters))"
    }
  }

  static func build(
    opts: CalendarOptions
  ) -> CalendarFilterI {
    var filters: [CalendarFilterI] = []

    if !opts.selectCalendarIds.isEmpty {
      let f: CalendarFilterI = CalendarFilter.SelectIds(uuids: opts.selectCalendarIds)
      filters.append(f)
      Log.write("added filter before: selectCalendars(\(opts.selectCalendarIds))")
    }

    if !opts.ignoreCalendarIds.isEmpty {
      let f: CalendarFilterI = CalendarFilter.IgnoreIds(uuids: opts.ignoreCalendarIds)
      filters.append(f)
      Log.write("added filter before: ignoreCalendars(\(opts.ignoreCalendarIds))")
    }

    if !opts.selectCalendarSources.isEmpty {
      let f: CalendarFilterI = CalendarFilter.SelectSources(sources: opts.selectCalendarSources)
      filters.append(f)
      Log.write("added filter before: selectSources(\(opts.selectCalendarSources))")
    }

    if !opts.ignoreCalendarSources.isEmpty {
      let f: CalendarFilterI = CalendarFilter.IgnoreSources(sources: opts.ignoreCalendarSources)
      filters.append(f)
      Log.write("added filter before: ignoreSources(\(opts.ignoreCalendarSources))")
    }

    if !opts.selectCalendarTypes.isEmpty {
      let f: CalendarFilterI = CalendarFilter.SelectTypes(types: opts.selectCalendarTypes)
      filters.append(f)
      Log.write("added filter before: selectCalendarTypes(\(opts.selectCalendarTypes))")
    }

    if !opts.ignoreCalendarTypes.isEmpty {
      let f: CalendarFilterI = CalendarFilter.IgnoreTypes(types: opts.ignoreCalendarTypes)
      filters.append(f)
      Log.write("added filter before: ignoreCalendarTypes(\(opts.ignoreCalendarTypes))")
    }

    return filters.isEmpty ?
      CalendarFilter.Accept() :
      CalendarFilter.Combined(filters: filters)
  }
}
