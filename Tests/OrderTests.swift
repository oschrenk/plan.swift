import Foundation
@testable import plan
import Testing

final class OrderTests {
  @Test func orderingOnTitleFull() throws {
    let eventA = Event.generate(title: "testA")
    let eventB = Event.generate(title: "testB")
    let events = [eventB, eventA]

    #expect(throws: Never.self) {
      let order = try #require(Order.parse(s: "title.full"))
      let comparator = EventComparator(order: order)
      let output = events.sorted(using: comparator)

      #expect(output == [eventA, eventB])
    }
  }

  @Test func reverseOrderingOnTitleFull() throws {
    let eventA = Event.generate(title: "testA")
    let eventB = Event.generate(title: "testB")
    let events = [eventB, eventA]

    #expect(throws: Never.self) {
      let order = try #require(Order.parse(s: "title.full:desc"))
      let comparator = EventComparator(order: order)
      let output = events.sorted(using: comparator)

      #expect(output == [eventB, eventA])
    }
  }

  @Test func orderingOnScheduleEndIn() throws {
    let now = Date()
    let closeEndDate = try #require(Calendar.current.date(
      byAdding: .hour, value: 1, to: now
    ))
    let farEndDate = try #require(Calendar.current.date(
      byAdding: .hour, value: 2, to: now
    ))
    let eventA = Event.generate(title: "testA", endDate: closeEndDate)
    let eventB = Event.generate(title: "testB", endDate: farEndDate)
    let events = [eventB, eventA]

    #expect(throws: Never.self) {
      let order = try #require(Order.parse(s: "schedule.end.in:desc"))
      let comparator = EventComparator(order: order)
      let output = events.sorted(using: comparator)

      #expect(output == [eventB, eventA])
    }
  }
}
