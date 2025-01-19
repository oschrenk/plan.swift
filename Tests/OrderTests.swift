@testable import plan
import Testing

@Suite final class OrderTests {
  @Test func testOrderingOnTitleFull() {
    let eventA = Event.generate(title: "testA")
    let eventB = Event.generate(title: "testB")
    let events = [eventB, eventA]

    #expect(throws: Never.self) {
      let order = Order.parse(s: "title.full")!
      let comparator = EventComparator(order: order)
      let output = events.sorted(using: comparator)[0].title.full

      #expect(output == eventA.title.full)
    }
  }

  @Test func testReverseOrderingOnTitleFull() {
    let eventA = Event.generate(title: "testA")
    let eventB = Event.generate(title: "testB")
    let events = [eventB, eventA]

    #expect(throws: Never.self) {
      let order = Order.parse(s: "title.full:desc")!
      let comparator = EventComparator(order: order)
      let output = events.sorted(using: comparator)[0].title.full

      #expect(output == eventB.title.full)
    }
  }
}
