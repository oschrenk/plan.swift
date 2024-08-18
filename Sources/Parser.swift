import Foundation
import struct Foundation.Calendar
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
  static func updateDate(date: Date, hourMinute: HourMinute) -> Date? {
    let calendar = FCalendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    components.hour = hourMinute.hour
    components.minute = hourMinute.minute
    return calendar.date(from: components)
  }

  static func parse(text: String) -> AddEvent? {
    let eventParser = Parse(input: Substring.self) {
      Skip { Whitespace() }
      Skip { Optionally { "-" } }
      Skip { Whitespace() }
      HourTimeParser()
      Skip { Whitespace() }
      Skip { Optionally { "-" } }
      Skip { Whitespace() }
      HourTimeParser()
      Rest().map { String($0).trimmingCharacters(in: .whitespaces) }
    }.map { (start: HourMinute, end: HourMinute, title: String) in
      let now = Date()
      let startsAt = updateDate(date: now, hourMinute: start)!
      let endsAt = updateDate(date: now, hourMinute: end)!
      let title = String(title)

      return AddEvent(title: title, startsAt: startsAt, endsAt: endsAt)
    }

    do {
      let event = try eventParser.parse(text)
      return event
    } catch {
      Swift.print(error)
      return nil
    }
  }
}
