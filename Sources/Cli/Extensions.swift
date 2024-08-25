import ArgumentParser
import EventKit

extension Array: ExpressibleByArgument where Element == String {
  public init?(argument: String) {
    self = argument.split(separator: ",").map { String($0) }
  }
}

extension EKCalendarType: ExpressibleByArgument {
  public init?(argument: String) {
    switch argument.lowercased() {
    case "local":
      self = .local
    case "birthday":
      self = .birthday
    case "exchange":
      self = .exchange
    case "caldav":
      self = .calDAV
    case "subscription":
      self = .subscription
    default:
      return nil
    }
  }
}
