import Foundation

enum Log {
  static var verbosity: Verbosity = .quiet

  static func setDebug(_ debug: Bool) {
    verbosity = debug ? .debug : .quiet
  }

  static func write(_ message: String) {
    switch verbosity {
    case .quiet:
      break
    case .debug:
      if let data = (message + "\n").data(using: .utf8) {
        FileHandle.standardError.write(data)
      }
    }
  }
}
