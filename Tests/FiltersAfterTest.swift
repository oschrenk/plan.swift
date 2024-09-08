@testable import plan
import XCTest

final class FiltersAfterTests: XCTestCase {
  private func genEvent(
    title: String = "unknown",
    tags: [String] = [],
    allDay: Bool = false
  ) -> Event {
    let id = UUID().uuidString
    let cal = Calendar.Unknown
    let title = Title(text: title)
    let schedule = Schedule(
      now: Date(),
      startDate: Date(),
      endDate: Date(),
      allDay: allDay
    )
    let location = ""
    let services: [String: String] = [:]

    return Event(
      id: id,
      calendar: cal,
      title: title,
      schedule: schedule,
      location: location,
      services: services,
      tags: tags
    )
  }

  func testAlwaysAccept() {
    let event = genEvent()
    let expected = true
    let actual = FiltersAfter.accept(event)

    XCTAssertEqual(actual, expected, "The event was not accepted")
  }

  func testIgnoreTagsNoTags() {
    let event = genEvent(tags: ["timeblock"])
    let expected = true
    let actual = FiltersAfter.ignoreTags(tags: [])(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testIgnoreTagsMatchingTags() {
    let event = genEvent(tags: ["timeblock"])
    let expected = false
    let actual = FiltersAfter.ignoreTags(tags: ["timeblock"])(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testIgnoreTagsNotMatchingTags() {
    let event = genEvent(tags: ["foo"])
    let expected = true
    let actual = FiltersAfter.ignoreTags(tags: ["timeblock"])(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testIgnoreAnAllDayEvent() {
    let event = genEvent(allDay: true)
    let expected = false
    let actual = FiltersAfter.ignoreAllDayEvents(event: event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptAnNonAllDayEvent() {
    let event = genEvent(allDay: false)
    let expected = true
    let actual = FiltersAfter.ignoreAllDayEvents(event: event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }

  func testIgnoringEventMatchingTitle() {
    let event = genEvent(title: "foo matching")
    let expected = false
    let actual = FiltersAfter.ignorePatternTitle(pattern: "foo")(event)

    XCTAssertEqual(actual, expected, "The event was falsely accepted")
  }

  func testAcceptingEventNotMatchingTitle() {
    let event = genEvent(title: "foo matching")
    let expected = true
    let actual = FiltersAfter.ignorePatternTitle(pattern: "bar")(event)

    XCTAssertEqual(actual, expected, "The event was falsely ignored")
  }
}
