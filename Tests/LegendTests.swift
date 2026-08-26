@testable import plan
import Testing

final class LegendTests {
  @Test func withoutEmoji() {
    let input = "Banana"
    let expected = Legend(description: "Banana", icon: "")
    let output = input.asLegend()

    #expect(output == expected)
  }

  @Test func leadingSimpleEmoji() {
    let input = "🍌 Banana"
    let expected = Legend(description: "Banana", icon: "🍌")
    let output = input.asLegend()

    #expect(output == expected)
  }

  @Test func leadingCombinedEmoji() {
    // 'Thumbs up' with 'Emoji Modifier Fitzpatrick Type-4':
    let input = "👍🏽 Thumb"
    let expected = Legend(description: "Thumb", icon: "👍🏽")
    let output = input.asLegend()

    #expect(output == expected)
  }
}
