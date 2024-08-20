import Foundation

struct StdErrOutputStream: TextOutputStream {
  func write(_ string: String) {
    guard !string.isEmpty else { return }
    fputs(string, stderr)
  }
}

enum StdErr {
  static func print(_ s: String) {
    var errStream = StdErrOutputStream()
    Swift.print(s, to: &errStream)
  }
}
