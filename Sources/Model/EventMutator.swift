import Foundation
import swift_lens

class EventTransformer {
  let rule: Rule

  init(rule: Rule) {
    self.rule = rule
  }

  func transform(event: Event) -> Event {
    if event.title.label.range(
      of: rule.regex, options: .regularExpression
    ) != nil {
      return event |> (Event.titleLens * Title.iconLens) *~ rule.icon
    }
    return event
  }
}
