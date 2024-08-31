# EventKit

## EKEvent

An EKEvent has three different identifiers
1. `calendarItemIdentifier` (via `EKCalendarItem`)
2. `calendarItemExternalIdentifier` (via `EKCalendarItem`)
3. `eventIdentifier` (via `EKEvent`)

My current understanding is to use
1. `calendarItemIdentifier` to interact with the Calendar.app e.g. show an event
2. `calendarItemExternalIdentifier` to interact with external systems
3. `eventIdentifier` to retrieve items from the underlying local event store

For more information

re 1) `calendarItemIdentifier`
> is set when the calendar item is created and can be used as a local identifier
see [also](https://developer.apple.com/documentation/eventkit/ekcalendaritem/1507075-calendaritemidentifier)
re 2) `calendarItemExternalIdentifier`
> identifier as provided by the calendar server.
> allows you to access the same event or reminder across multiple devices
see [also](https://developer.apple.com/documentation/eventkit/ekcalendaritem/1507283-calendaritemexternalidentifier)

re 3) `eventIdentifier`
> use this identifier to look up an event with the `EKEventStore` method `event(withIdentifier:)`
see [also](https://developer.apple.com/documentation/eventkit/ekevent/1507437-eventidentifier)

For now we pick `calendarItemIdentifier` as the leading identifier as the app is mostly interested in interacting with the Calendar.app

### Calendars

- have an `id`, namely `calendarIdentifier` (upper-case [UUID v4](https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_(random)))
- have a type `EKCalendar.type`: `EKCalendarType`
  - `local` A local calendar.
  - `calDAV` A CalDAV or iCloud calendar.
  - `exchange` An Exchange calendar.
  - `subscription` A locally subscribed calendar.
  - `birthday` A birthday calendar.
- have a color `cgcolor`

### Schedule

- `EKEvent` has field `status` of type [EKEventStatus](https://developer.apple.com/documentation/eventkit/ekeventstatus)
  - `none`, `confirmed`, `tentative`, `canceled`
- `EKCalendarItem` has `hasAttendees`
- `EKCalendarItem` has `timeZone`
- `EKCalendarItem` has `location`
  - which can hold a url

## Appendix

- [EKEventStore](https://developer.apple.com/documentation/eventkit/ekeventstore)
- [EKCalendarItem](https://developer.apple.com/documentation/eventkit/ekcalendaritem)
- [EKEvent](https://developer.apple.com/documentation/eventkit/ekevent) inherits from `EKCalendarItem`
- [EKCalendar](https://developer.apple.com/documentation/eventkit/ekcalendar)
- [EKCalendarType](https://developer.apple.com/documentation/eventkit/ekcalendartype)
