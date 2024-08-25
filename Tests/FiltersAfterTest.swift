@testable import plan
import XCTest

final class FiltersAfterTests: XCTestCase {
  private func genEvent() -> Event {
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
    let tags: [String] = []
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
}
