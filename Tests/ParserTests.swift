import Foundation
@testable import plan
import Testing

final class ParserTests {
  @Test func parseWithLeadingDash() throws {
    let input = "- 10:00 - 12:00 🥗 Lunch"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: nil
    )
    let output = try #require(Parser.parse(text: input))

    #expect(output.title == expected.title)
  }

  @Test func parseWithoutLeadingDash() throws {
    let input = "10:00 - 12:00 🥗 Lunch"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: nil
    )
    let output = try #require(Parser.parse(text: input))

    #expect(output.title == expected.title)
  }

  @Test func parseTag() throws {
    let input = "10:00 - 12:00 🥗 Lunch #calendar/foo"
    let expected = AddEvent(
      title: "🥗 Lunch",
      startsAt: Date(),
      endsAt: Date(),
      tag: "calendar/foo"
    )
    let output = try #require(Parser.parse(text: input))

    #expect(output.title == expected.title)
    #expect(output.tag == expected.tag)
  }
}
