import ArgumentParser
import Foundation

enum Field: String, ExpressibleByArgument {
  case start
}

enum Direction: String, ExpressibleByArgument {
  case asc, desc
}
