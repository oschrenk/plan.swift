@testable import plan
import Testing

@Suite final class OrderTests {
  @Test func testKeyPathOnKeywords() {
    let eventA = Event.generate(title: "testA")
    let eventB = Event.generate(title: "testB")
    let events = [eventB, eventA]

    #expect(throws: Never.self) {
      let order = Order.parse(s: "title.full")!
      let comparator = OrderComparator(order: order)
      let output = events.sorted(using: comparator)[0].title.full

      #expect(output == eventA.title.full)
    }
  }

  @Test func testNotComparable() {
    let event = Event.generate(title: "test")
    #expect(throws: Object.PathError.self) {
      try Object.valueForKeyPath(event, "schedule.start")
    }
  }
}
