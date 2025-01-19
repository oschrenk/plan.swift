import Foundation
import Parsing

struct HourMinute {
  let hour: Int
  let minute: Int
}

struct HourTimeParser: ParserPrinter {
  var body: some ParserPrinter<Substring, HourMinute> {
    ParsePrint(.memberwise(HourMinute.init)) {
      Digits(2).filter { $0 < 24 }
      ":"
      Digits(2).filter { $0 < 60 }
    }
  }
}

class Parser {
  private static func updateDate(date: Date, hourMinute: HourMinute) -> Date? {
    let calendar = FCalendar.current
    var components = calendar.dateComponents(
      [.year, .month, .day, .hour, .minute, .second],
      from: date
    )
    components.hour = hourMinute.hour
    components.minute = hourMinute.minute
    return calendar.date(from: components)
  }

  static func parse(text: String) -> AddEvent? {
    let lowerCaseLetters = CharacterSet.lowercaseLetters
    let specialChars = CharacterSet(charactersIn: "-_/")
    let digits: CharacterSet = .decimalDigits

    let eventParser = Parse(input: Substring.self) {
      Skip {
        Whitespace()
        Optionally { "-" }
        Whitespace()
      }
      HourTimeParser()
      Skip { Whitespace() }
      Skip { Optionally { "-" } }
      Skip { Whitespace() }
      HourTimeParser()
      Whitespace()
      Prefix { $0 != "#" }.map(String.init)
      Optionally {
        "#"
        lowerCaseLetters.union(specialChars).union(digits).map(String.init)
      }
    }.map { (start: HourMinute, end: HourMinute, title: String, maybeTag: String?) in
      let now = Date()
      let startsAt = updateDate(date: now, hourMinute: start)!
      let endsAt = updateDate(date: now, hourMinute: end)!
      let title = String(title.trimmingCharacters(in: .whitespacesAndNewlines))

      return AddEvent(title: title, startsAt: startsAt, endsAt: endsAt, tag: maybeTag)
    }

    do {
      return try eventParser.parse(text)
    } catch {
      StdErr.print("\(error)")
      return nil
    }
  }
}
