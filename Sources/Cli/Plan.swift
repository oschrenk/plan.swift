import EventKit
import Foundation

class Plan {
  func events(
    start: Date,
    end: Date,
    opts: AllOptions,
    selector: EventSelectorI,
    transformer: EventTransformer
  ) -> [Event] {
    Log.setDebug(opts.general.debug)

    let unsortedEvents = EventService(repo: EventRepo())
      .fetch(
        start: start,
        end: end,
        calendarFilter: CalendarFilter.build(
          opts: opts.calendar
        ),
        eventFilter: EventFilter.build(
          opts: opts.events
        )
      )

    return selector
      .select(events: unsortedEvents)
      .map { transformer.transform(event: $0) }
  }
}
