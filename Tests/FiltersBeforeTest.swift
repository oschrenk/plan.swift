import EventKit

@testable import plan
import XCTest

final class FiltersBeforeTests: XCTestCase {
  private var eventStore: EKEventStore = .init()

  func genEKEvent(calendar: EKCalendar? = nil) -> EKEvent {
    let event = EKEvent(eventStore: eventStore)
    event.calendar = calendar
    return event
  }

  override func setUp() {
    super.setUp()
    eventStore = EKEventStore()
  }

  override func tearDown() {
    eventStore.reset()
    super.tearDown()
  }

  func testAlwaysAccept() {
    let event = genEKEvent()
    let expected = true
    let actual = FiltersBefore.accept(event)

    XCTAssertEqual(actual, expected, "The event was not accepted")
  }

  func testSelectCalendarsMatching() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = true
    let actual = FiltersBefore.selectCalendars(
      calendars: [event.calendar.calendarIdentifier])(event)

    XCTAssertEqual(actual, expected, "The event was not accepted")
  }

  func testSelectCalendarsEmptyArray() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = true
    let actual = FiltersBefore.selectCalendars(calendars: [])(event)

    XCTAssertEqual(actual, expected, "The event was not accepted")
  }

  func testIgnoreCalendarsMatching() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = false
    let actual = FiltersBefore.ignoreCalendars(
      calendars: [event.calendar.calendarIdentifier])(event)

    XCTAssertEqual(actual, expected, "The event was accepted")
  }

  func testIgnoreCalendarsEmptyArray() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = true
    let actual = FiltersBefore.ignoreCalendars(calendars: [])(event)

    XCTAssertEqual(actual, expected, "The event was not accepted")
  }

  func testIgnoreCalendarTypesMatching() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = false
    let actual = FiltersBefore.ignoreCalendarTypes(types: [event.calendar.type])(event)

    XCTAssertEqual(actual, expected, "The event was accepted")
  }

  func testIgnoreCalendarTypesEmptyArray() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = true
    let actual = FiltersBefore.ignoreCalendarTypes(types: [])(event)

    XCTAssertEqual(actual, expected, "The event was rejected")
  }

  func testSelectCalendarTypesMatching() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = true
    let actual = FiltersBefore.selectCalendarTypes(types: [event.calendar.type])(event)

    XCTAssertEqual(actual, expected, "The event was rejected")
  }

  func testSelectCalendarTypesNotMatching() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = false
    let actual = FiltersBefore.selectCalendarTypes(types: [EKCalendarType.birthday])(event)

    XCTAssertEqual(actual, expected, "The event was accepted")
  }

  func testSelectCalendarTypesEmptyArray() {
    let event = genEKEvent(calendar: eventStore.defaultCalendarForNewEvents)
    let expected = true
    let actual = FiltersBefore.selectCalendarTypes(types: [])(event)

    XCTAssertEqual(actual, expected, "The event was rejected")
  }
}
