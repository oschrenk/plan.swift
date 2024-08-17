import Foundation
import struct Foundation.Calendar
import Parsing

class Parser {
  static func updateDate(date: Date, hour: Int, minute: Int) -> Date? {
    let calendar = FCalendar.current
    var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
    components.hour = hour
    components.minute = minute
    return calendar.date(from: components)
  }

  static func parse(text: String) -> AddEvent? {
    let eventParser = Parse(input: Substring.self) {
      Skip { Whitespace() }
      Skip { Optionally { "-" } }
      Skip { Whitespace() }
      Digits(2).filter { $0 < 24 }
      ":"
      Digits(2).filter { $0 < 60 }
      Skip { Whitespace() }
      "-"
      Skip { Whitespace() }
      Digits(2).filter { $0 < 24 }
      ":"
      Digits(2).filter { $0 < 60 }
      Skip { Whitespace() }
      Rest().map { String($0).trimmingCharacters(in: .whitespaces) }
    }.map { (a: Int, b: Int, c: Int, d: Int, e: String) in
      let now = Date()
      let startsAt = updateDate(date: now, hour: a, minute: b)!
      let endsAt = updateDate(date: now, hour: c, minute: d)!
      let title = String(e)

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
