import Foundation

class Log {
  static var verbosity: Verbosity = .quiet

  static func print(message: String) {
    switch verbosity {
    case .quiet:
      fallthrough
    case .normal:
      if let data = message.data(using: .utf8) {
        FileHandle.standardError.write(data)
      }
    }
  }
}
