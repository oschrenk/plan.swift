import Foundation
import swift_lens

class EventTransformer {
  let rules: [Rule]

  init(rule: Rule) {
    rules = [rule]
  }

  init(rules: [Rule]) {
    self.rules = rules
  }

  func transform(event: Event) -> Event {
    for rule in rules where event.title.label.range(
      of: rule.regex, options: .regularExpression
    ) != nil {
      let withIcon = event
        |> (Event.titleLens * Title.iconLens) *~ rule.icon
      let withFull = withIcon
        |> (Event.titleLens * Title.fullLens) *~ "\(rule.icon) \(event.title.full)"
      return withFull
    }
    return event
  }
}
