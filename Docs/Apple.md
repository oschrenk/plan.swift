# Apple Developer Documentation

## Infos

### Calendars
have an identifier
var calendarIdentifier: String
which is an uppercases UUIDv4 string

Calendars have a type

`EKCalendar.type`: `EKCalendarType`

- `local` A local calendar.
- `calDAV` A CalDAV or iCloud calendar.
- `exchange` An Exchange calendar.
- `subscription` A locally subscribed calendar.
- `birthday` A birthday calendar.

Calendars have a color

- `cgcolor`

### Scheduling

- `EKEvent` has field `status` of type [EKEventStatus](https://developer.apple.com/documentation/eventkit/ekeventstatus)
  - `none`, `confirmed`, `tentative`, `canceled`
- `EKCalendarItem` has `hasAttendees`
- `EKCalendarItem` has `location`
  - which can hold a url
- `EKCalendarItem` has `timeZone`

## Appendix

- [EKCalendarItem](https://developer.apple.com/documentation/eventkit/ekcalendaritem)
- [EKEvent](https://developer.apple.com/documentation/eventkit/ekevent) inherits from `EKCalendarItem`
- [EKCalendar](https://developer.apple.com/documentation/eventkit/ekcalendar)
- [EKCalendarType](https://developer.apple.com/documentation/eventkit/ekcalendartype)
