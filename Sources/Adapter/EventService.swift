import Foundation

final class EventService {
  private let eventRepo: EventRepo

  init(repo: EventRepo) {
    eventRepo = repo
  }

  /// Returns a list of calendars
  ///
  /// - Parameters:
  ///     - filter: A filter to select certain calendars
  func calendars(filter: CalendarFilterI) -> [PlanCalendar] {
    eventRepo.fetchCalendars(filter: filter)
  }

  /// Returns a list of events
  ///
  /// We filter on two levels:
  /// 1. Calendar: Done on repository level
  /// 2. Event: Done on service level
  ///
  /// Re 1) This is done because the underlying EKEventStore supports and
  ///       promotes building calendar predicates
  /// Re 2) This is done because of flexibility and lack of support in
  ///       EKEventStore level
  ///
  /// - Parameters:
  ///     - start: Minimum start date of event
  ///     - end: Maximum start date of event
  ///     - calendarFilter: A filter to select certain calendars
  ///     - eventFilter: A filter to select certain events
  ///
  /// - Returns: a list of events
  func fetch(
    start: Date,
    end: Date,
    calendarFilter: CalendarFilterI,
    eventFilter: EventFilterI
  ) -> [Event] {
    return eventRepo
      .fetchEvents(start, end, calendarFilter)
      .filter { event in
        eventFilter.accept(event)
      }
  }

  /// Add a new Event
  ///
  /// - Parameters:
  ///     - event: New event
  func addEvent(event: AddEvent) {
    eventRepo.addEvent(event: event)
  }
}
