import EventKit

@testable import plan
import XCTest

final class FiltersBeforeTests: XCTestCase {
  private let eventStore = EKEventStore()
  func genEKEvent() -> EKEvent {
    let event = EKEvent(eventStore: eventStore)
    return event
  }

  func testAlwaysAccept() {
    let event = genEKEvent()
    let expected = true
    let actual = FiltersBefore.accept(event)

    XCTAssertEqual(actual, expected, "The event was not accepted")
  }
}
