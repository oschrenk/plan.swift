@testable import plan
import Testing

@Suite final class LegendTests {
  @Test func testWithoutEmoji() {
    let input = "Banana"
    let expected = Legend(description: "Banana", icon: "")
    let output = input.asLegend()

    #expect(output == expected)
  }

  @Test func testLeadingSimpleEmoji() {
    let input = "🍌 Banana"
    let expected = Legend(description: "Banana", icon: "🍌")
    let output = input.asLegend()

    #expect(output == expected)
  }

  @Test func testLeadingCombinedEmoji() {
    // 'Thumbs up' with 'Emoji Modifier Fitzpatrick Type-4':
    let input = "👍🏽 Thumb"
    let expected = Legend(description: "Thumb", icon: "👍🏽")
    let output = input.asLegend()

    #expect(output == expected)
  }
}
