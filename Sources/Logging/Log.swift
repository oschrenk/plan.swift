import Foundation

class Log {
  static var verbosity: Verbosity = .quiet

  static func write(message: String) {
    switch verbosity {
    case .quiet:
      break
    case .normal:
      if let data = (message + "\n").data(using: .utf8) {
        FileHandle.standardError.write(data)
      }
    }
  }
}
