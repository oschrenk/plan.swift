@testable import plan
import XCTest

final class FiltersAfterTests: XCTestCase {
  private func genEvent(tags: [String] = []) -> Event {
    let id = UUID().uuidString
    let cal = Calendar.Unknown
    let title = Title(text: "unknown")
    let schedule = Schedule(
      now: Date(),
      startDate: Date(),
      endDate: Date()
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
}
