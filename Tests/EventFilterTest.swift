@testable import plan
import XCTest

final class EventFilterTests: XCTestCase {
  func testAlwaysAccept() {
    let event = Event.generate()
    let expected = true
    let actual = EventFilter.Accept().accept(event)

    XCTAssertEqual(actual, expected, "The event was not accepted")
  }

  func testIgnoreTagsNoTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = true
    let actual = EventFilter.IgnoreTags(tags: []).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testIgnoreTagsMatchingTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = false
    let actual = EventFilter.IgnoreTags(tags: ["timeblock"]).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testIgnoreTagsNotMatchingTags() {
    let event = Event.generate(tags: ["foo"])
    let expected = true
    let actual = EventFilter.IgnoreTags(tags: ["timeblock"]).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testIgnoreAnAllDayEvent() {
    let event = Event.generate(allDay: true)
    let expected = false
    let actual = EventFilter.IgnoreAllDay().accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptAnNonAllDayEvent() {
    let event = Event.generate(allDay: false)
    let expected = true
    let actual = EventFilter.IgnoreAllDay().accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testIgnoringEventMatchingTitle() {
    let event = Event.generate(title: "foo matching")
    let expected = false
    let actual = EventFilter.IgnorePatternTitle(pattern: "foo").accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptingEventNotMatchingTitle() {
    let event = Event.generate(title: "foo matching")
    let expected = true
    let actual = EventFilter.IgnorePatternTitle(pattern: "bar").accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testAcceptingEventWithAtLeastTwoAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = true
    let actual = EventFilter.MinNumAttendees(count: 2).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testAcceptingEventWithTooFewAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = false
    let actual = EventFilter.MinNumAttendees(count: 3).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptingEventWithFewAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = true
    let actual = EventFilter.MaxNumAttendees(count: 3).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testAcceptingEventWithTooManyAttendees() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = false
    let actual = EventFilter.MaxNumAttendees(count: 2).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptCombinedFilter() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = true
    let min = EventFilter.MinNumAttendees(count: 2)
    let max = EventFilter.MaxNumAttendees(count: 4)

    let actual = EventFilter.Combined(filters: [min, max]).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testRejectCombinedFilter() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = false
    let min = EventFilter.MinNumAttendees(count: 4)
    let max = EventFilter.MaxNumAttendees(count: 2)

    let actual = EventFilter.Combined(filters: [min, max]).accept(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }
}
