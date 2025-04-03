import Foundation
import when

enum DateArgument {
  static func parse(s: String) -> Date? {
    let parser = DateParser(rules: EN.all + Common.all)
    do {
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      // try iso date formatting manually
      // until swift-when supports iso dates/time
      if let date = formatter.date(from: s) {
        return date
      } else {
        // try natural date parsing
        let result = try parser.parse(text: s, base: Date())
        return result.date
      }
    } catch {
      return nil
    }
  }
}
