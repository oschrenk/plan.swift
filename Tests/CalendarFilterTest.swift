import EventKit

@testable import plan
import XCTest

final class CalendarFilterTests: XCTestCase {
  func testAlwaysAccept() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.accept(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testSelectCalendarsMatching() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.select(uuids: [calendar.id])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testSelectCalendarsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.select(uuids: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testIgnoreCalendarsMatching() {
    let calendar = PlanCalendar.generate()
    let expected = false
    let actual = CalendarFilter.ignore(uuids: [calendar.id])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarsEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.ignore(uuids: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was not accepted")
  }

  func testIgnoreCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = false
    let actual = CalendarFilter.ignoreSources(sources: [source])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarSourcesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.ignoreSources(sources: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarSourcesMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = true
    let actual = CalendarFilter.selectSources(sources: [source])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarSourcesNotMatching() {
    let source = "Personal"
    let calendar = PlanCalendar.generate(source: source)
    let expected = false
    let actual = CalendarFilter.selectSources(sources: ["not-existing"])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testSelectCalendarSourcesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.selectSources(sources: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testIgnoreCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = PlanCalendar.generate(type: type)
    let expected = false
    let actual = CalendarFilter.ignoreTypes(types: [type])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testIgnoreCalendarTypesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.ignoreTypes(types: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarTypesMatching() {
    let type = EKCalendarType.birthday
    let calendar = PlanCalendar.generate(type: type)
    let expected = true
    let actual = CalendarFilter.selectTypes(types: [type])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }

  func testSelectCalendarTypesNotMatching() {
    let type = EKCalendarType.calDAV
    let calendar = PlanCalendar.generate(type: type)
    let expected = false
    let actual = CalendarFilter.selectTypes(types: [EKCalendarType.birthday])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was accepted")
  }

  func testSelectCalendarTypesEmptyArray() {
    let calendar = PlanCalendar.generate()
    let expected = true
    let actual = CalendarFilter.selectTypes(types: [])(calendar)

    XCTAssertEqual(actual, expected, "The calendar was rejected")
  }
}
