import Foundation
@testable import plan
import Testing

@Suite final class EventFilterTests {
  @Test func testAlwaysAccept() {
    let event = Event.generate()
    let expected = true
    let actual = EventFilter.Accept().accept(event)

    #expect(actual == expected)
  }

  @Test func testIgnoreTagsNoTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = true
    let actual = EventFilter.IgnoreTags(tags: []).accept(event)

    #expect(actual == expected)
  }

  @Test func testIgnoreTagsMatchingTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = false
    let actual = EventFilter.IgnoreTags(tags: ["timeblock"]).accept(event)

    #expect(actual == expected)
  }

  @Test func testIgnoreTagsNotMatchingTags() {
    let event = Event.generate(tags: ["foo"])
    let expected = true
    let actual = EventFilter.IgnoreTags(tags: ["timeblock"]).accept(event)

    #expect(actual == expected)
  }

  @Test func testSelectTagsMatchingTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = true
    let actual = EventFilter.SelectTags(tags: ["timeblock"]).accept(event)

    #expect(actual == expected)
  }

  @Test func testIgnoreAnAllDayEvent() {
    let event = Event.generate(allDay: true)
    let expected = false
    let actual = EventFilter.IgnoreAllDay().accept(event)

    #expect(actual == expected)
  }

  @Test func testSelectAnAllDayEvent() {
    let event = Event.generate(allDay: true)
    let expected = true
    let actual = EventFilter.SelectAllDay().accept(event)

    #expect(actual == expected)
  }

  @Test func testAcceptAnNonAllDayEvent() {
    let event = Event.generate(allDay: false)
    let expected = true
    let actual = EventFilter.IgnoreAllDay().accept(event)

    #expect(actual == expected)
  }

  @Test func testIgnoringEventMatchingTitle() {
    let event = Event.generate(title: "foo matching")
    let expected = false
    let actual = EventFilter.IgnorePatternTitle(pattern: "foo").accept(event)

    #expect(actual == expected)
  }

  @Test func testNotSelectingEventNotMatchingTitle() {
    let event = Event.generate(title: "Development standup")
    let expected = false
    let actual = EventFilter.SelectPatternTitle(pattern: "foo").accept(event)

    #expect(actual == expected)
  }

  @Test func testAcceptingEventNotMatchingTitle() {
    let event = Event.generate(title: "foo matching")
    let expected = true
    let actual = EventFilter.IgnorePatternTitle(pattern: "bar").accept(event)

    #expect(actual == expected)
  }

  @Test func testAcceptingEventWithAtLeastTwoAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = true
    let actual = EventFilter.MinNumAttendees(count: 2).accept(event)

    #expect(actual == expected)
  }

  @Test func testAcceptingEventWithTooFewAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = false
    let actual = EventFilter.MinNumAttendees(count: 3).accept(event)

    #expect(actual == expected)
  }

  @Test func testAcceptingEventWithFewAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = true
    let actual = EventFilter.MaxNumAttendees(count: 3).accept(event)

    #expect(actual == expected)
  }

  @Test func testAcceptingEventWithTooManyAttendees() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = false
    let actual = EventFilter.MaxNumAttendees(count: 2).accept(event)

    #expect(actual == expected)
  }

  @Test func testAcceptingEventWithMinDuration() {
    let now = Date()
    let start = FCalendar.current.date(byAdding: .minute, value: 0, to: now)!
    let end = FCalendar.current.date(byAdding: .minute, value: 200, to: now)!

    let event = Event.generate(startDate: start, endDate: end)
    let expected = true
    let actual = EventFilter.MinDuration(minutes: 199).accept(event)

    #expect(actual == expected)
  }

  @Test func testNotAcceptingEventWithMaxDuration() {
    let now = Date()
    let start = FCalendar.current.date(byAdding: .minute, value: 0, to: now)!
    let end = FCalendar.current.date(byAdding: .minute, value: 200, to: now)!

    let event = Event.generate(startDate: start, endDate: end)
    let expected = false
    let actual = EventFilter.MaxDuration(minutes: 100).accept(event)

    #expect(actual == expected)
  }

  @Test func testAcceptCombinedFilter() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = true
    let min = EventFilter.MinNumAttendees(count: 2)
    let max = EventFilter.MaxNumAttendees(count: 4)

    let actual = EventFilter.Combined(filters: [min, max]).accept(event)

    #expect(actual == expected)
  }

  @Test func testRejectCombinedFilter() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = false
    let min = EventFilter.MinNumAttendees(count: 4)
    let max = EventFilter.MaxNumAttendees(count: 2)

    let actual = EventFilter.Combined(filters: [min, max]).accept(event)

    #expect(actual == expected)
  }
}
