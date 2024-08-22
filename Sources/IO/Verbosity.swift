import ArgumentParser

enum Verbosity: String, ExpressibleByArgument {
  case quiet, debug
}
