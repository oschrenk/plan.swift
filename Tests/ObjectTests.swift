@testable import plan
import Testing

final class ObjectTests {
  @Test func keyPathOnKeywords() {
    let event = Event.generate(title: "test")

    #expect(throws: Never.self) {
      let expected = try Object.valueForKeyPath(event, "schedule.start.in") as? Int ?? -1
      let output = 0

      #expect(output == expected)
    }
  }

  @Test func notComparable() {
    let event = Event.generate(title: "test")
    #expect(throws: Object.PathError.self) {
      try Object.valueForKeyPath(event, "schedule.start")
    }
  }
}
