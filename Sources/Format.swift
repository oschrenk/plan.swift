import ArgumentParser

enum EventFormat: String, ExpressibleByArgument {
  case json, markdown
}
