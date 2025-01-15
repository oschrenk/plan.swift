@testable import plan
import XCTest

final class EventFilterTests: XCTestCase {
  func testAlwaysAccept() {
    let event = Event.generate()
    let expected = true
    let actual = EventFilter.accept(event)

    XCTAssertEqual(actual, expected, "The event was not accepted")
  }

  func testIgnoreTagsNoTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = true
    let actual = EventFilter.ignoreTags(tags: [])(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testIgnoreTagsMatchingTags() {
    let event = Event.generate(tags: ["timeblock"])
    let expected = false
    let actual = EventFilter.ignoreTags(tags: ["timeblock"])(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testIgnoreTagsNotMatchingTags() {
    let event = Event.generate(tags: ["foo"])
    let expected = true
    let actual = EventFilter.ignoreTags(tags: ["timeblock"])(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testIgnoreAnAllDayEvent() {
    let event = Event.generate(allDay: true)
    let expected = false
    let actual = EventFilter.ignoreAllDay(event: event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptAnNonAllDayEvent() {
    let event = Event.generate(allDay: false)
    let expected = true
    let actual = EventFilter.ignoreAllDay(event: event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testIgnoringEventMatchingTitle() {
    let event = Event.generate(title: "foo matching")
    let expected = false
    let actual = EventFilter.ignorePatternTitle(pattern: "foo")(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptingEventNotMatchingTitle() {
    let event = Event.generate(title: "foo matching")
    let expected = true
    let actual = EventFilter.ignorePatternTitle(pattern: "bar")(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testAcceptingEventWithAtLeastTwoAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = true
    let actual = EventFilter.minNumAttendees(number: 2)(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testAcceptingEventWithTooFewAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = false
    let actual = EventFilter.minNumAttendees(number: 3)(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptingEventWithFewAttendees() {
    let event = Event.generate(attendees: ["personA", "personB"])
    let expected = true
    let actual = EventFilter.maxNumAttendees(number: 3)(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testAcceptingEventWithTooManyAttendees() {
    let event = Event.generate(attendees: ["personA", "personB", "personC"])
    let expected = false
    let actual = EventFilter.maxNumAttendees(number: 2)(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }
}
