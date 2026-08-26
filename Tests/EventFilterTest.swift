import Foundation
@testable import plan
import Testing

final class EventFilterTests {
  @Test func alwaysAccept() {
    let event = Event.generate()
    let expected = true
    let actual = EventFilter.Accept().accept(event)

    #expect(actual == expected)
  }

  @Test func ignoreTagsNoTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = true
    let actual = EventFilter.IgnoreTags(tags: []).accept(event)

    #expect(actual == expected)
  }

  @Test func ignoreTagsMatchingTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = false
    let actual = EventFilter.IgnoreTags(tags: ["timeblock"]).accept(event)

    #expect(actual == expected)
  }

  @Test func ignoreTagsNotMatchingTags() {
    let event = Event.generate(tags: ["foo"])
    let expected = true
    let actual = EventFilter.IgnoreTags(tags: ["timeblock"]).accept(event)

    #expect(actual == expected)
  }

  @Test func selectTagsMatchingTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = true
    let actual = EventFilter.SelectTags(tags: ["timeblock"]).accept(event)

    #expect(actual == expected)
  }

  @Test func ignoreServicesNoServices() {
    let event = Event.generate()
    let expected = true
    let actual = EventFilter.IgnoreServices(services: []).accept(event)

    #expect(actual == expected)
  }

  @Test func ignoreServiceMatchingService() {
    let event = Event.generate(services: ["zoom": "example"])
    let expected = false
    let actual = EventFilter.IgnoreServices(services: ["zoom"]).accept(event)

    #expect(actual == expected)
  }

  @Test func ignoreServiceNotMatchingServices() {
    let event = Event.generate(services: ["zoom": "example"])
    let expected = true
    let actual = EventFilter.IgnoreServices(services: ["teams"]).accept(event)

    #expect(actual == expected)
  }

  @Test func selectServicesMatchingServices() {
    let event = Event.generate(services: ["zoom": "example"])
    let expected = true
    let actual = EventFilter.SelectServices(services: ["zoom"]).accept(event)

    #expect(actual == expected)
  }

  @Test func ignoreAnAllDayEvent() {
    let event = Event.generate(allDay: true)
    let expected = false
    let actual = EventFilter.IgnoreAllDay().accept(event)

    #expect(actual == expected)
  }

  @Test func selectAnAllDayEvent() {
    let event = Event.generate(allDay: true)
    let expected = true
    let actual = EventFilter.SelectAllDay().accept(event)

    #expect(actual == expected)
  }

  @Test func acceptAnNonAllDayEvent() {
    let event = Event.generate(allDay: false)
    let expected = true
    let actual = EventFilter.IgnoreAllDay().accept(event)

    #expect(actual == expected)
  }

  @Test func ignoringEventMatchingTitle() {
    let event = Event.generate(title: "foo matching")
    let expected = false
    let actual = EventFilter.IgnoreTitle(pattern: "foo").accept(event)

    #expect(actual == expected)
  }

  @Test func notSelectingEventNotMatchingTitle() {
    let event = Event.generate(title: "Development standup")
    let expected = false
    let actual = EventFilter.SelectTitle(pattern: "foo").accept(event)

    #expect(actual == expected)
  }

  @Test func acceptingEventNotMatchingTitle() {
    let event = Event.generate(title: "foo matching")
    let expected = true
    let actual = EventFilter.IgnoreTitle(pattern: "bar").accept(event)

    #expect(actual == expected)
  }

  @Test func acceptingEventWithAtLeastTwoAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = true
    let actual = EventFilter.MinNumAttendees(count: 2).accept(event)

    #expect(actual == expected)
  }

  @Test func acceptingEventWithTooFewAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = false
    let actual = EventFilter.MinNumAttendees(count: 3).accept(event)

    #expect(actual == expected)
  }

  @Test func acceptingEventWithFewAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = true
    let actual = EventFilter.MaxNumAttendees(count: 3).accept(event)

    #expect(actual == expected)
  }

  @Test func acceptingEventWithTooManyAttendees() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = false
    let actual = EventFilter.MaxNumAttendees(count: 2).accept(event)

    #expect(actual == expected)
  }

  @Test func acceptingEventWithMinDuration() throws {
    let now = Date()
    let start = try #require(FCalendar.current.date(byAdding: .minute, value: 0, to: now))
    let end = try #require(FCalendar.current.date(byAdding: .minute, value: 200, to: now))

    let event = Event.generate(startDate: start, endDate: end)
    let expected = true
    let actual = EventFilter.MinDuration(minutes: 199).accept(event)

    #expect(actual == expected)
  }

  @Test func notAcceptingEventWithMaxDuration() throws {
    let now = Date()
    let start = try #require(FCalendar.current.date(byAdding: .minute, value: 0, to: now))
    let end = try #require(FCalendar.current.date(byAdding: .minute, value: 200, to: now))

    let event = Event.generate(startDate: start, endDate: end)
    let expected = false
    let actual = EventFilter.MaxDuration(minutes: 100).accept(event)

    #expect(actual == expected)
  }

  @Test func acceptCombinedFilter() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = true
    let min = EventFilter.MinNumAttendees(count: 2)
    let max = EventFilter.MaxNumAttendees(count: 4)

    let actual = EventFilter.Combined(filters: [min, max]).accept(event)

    #expect(actual == expected)
  }

  @Test func rejectCombinedFilter() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = false
    let min = EventFilter.MinNumAttendees(count: 4)
    let max = EventFilter.MaxNumAttendees(count: 2)

    let actual = EventFilter.Combined(filters: [min, max]).accept(event)

    #expect(actual == expected)
  }
}
