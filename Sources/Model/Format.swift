import ArgumentParser

enum EventFormat: String, ExpressibleByArgument {
  case json, markdown
}

enum CalendarFormat: String, ExpressibleByArgument {
  case json, plain
}
