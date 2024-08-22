import Foundation

class Log {
  static var verbosity: Verbosity = .quiet

  static func setDebug(_ debug: Bool) {
    if debug {
      Log.verbosity = Verbosity.debug
    } else {
      Log.verbosity = Verbosity.quiet
    }
  }

  static func write(message: String) {
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
