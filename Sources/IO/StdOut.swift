import Foundation

struct StdOutOutputStream: TextOutputStream {
  func write(_ string: String) {
    guard !string.isEmpty else { return }
    fputs(string, stdout)
  }
}

enum StdOut {
  static func print(_ string: String) {
    var outStream = StdOutOutputStream()
    Swift.print(string, to: &outStream)
  }
}
