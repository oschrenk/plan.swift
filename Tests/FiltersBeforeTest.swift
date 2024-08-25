import EventKit

@testable import plan
import XCTest

final class FiltersBeforeTests: XCTestCase {
  private var eventStore: EKEventStore = .init()

  func genEKEvent() -> EKEvent {
    let event = EKEvent(eventStore: eventStore)
    return event
  }

  override func setUp() {
    super.setUp()
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
}
