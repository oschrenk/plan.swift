# README

A macOS tool to fetch (the next) calendar events as json

## Features

- returns JSON by default
- separates leading emojis from event title, and gives you the emoji, short and full title
- rejects events based on tags `tag:example` within the event notes
- start and end time in relative and absolute terms
- uses the [`calendarItemIdentifier`](https://developer.apple.com/documentation/eventkit/ekcalendaritem/1507075-calendaritemidentifier) as the leading identifier (to allow easy interaction with Calendar.app)
- returns a `url` that can be used to `open $URL` to show the particular event in Calendar.app

## Usage

Example commands (use `plan --help` for full usage)

- `plan today` Returns all events for today
- `plan today --format=markdown` Returns all events for today in markdown
- `plan next` Returns the current or next event within the next hour
- `plan next --reject-tag somekeyword` Returns the current or next event within the next hour ignoring events which notes have text containing `tag:somekeyword`
- `plan calendars` List available calendars

Example output in json

```json
[
  {
    "id": "UUID:UUID",
    "calendar": {
      "id": "UUID",
      "label": "Some calendar"
    },
    "label": "🏆 Release plan",
    "legend": {
      "description": "Release plan",
      "icon": "🏆",
    },
    "starts_at": "2024-08-09T18:00:00+02:00",
    "starts_in": 30,
    "ends_at": "2024-08-09T17:00:00+02:00",
    "ends_in": 90
 }
]
```

Example output in markdown

```markdown
- 18:00 - 19:00 🏆 Release plan
```

## Installation

**Via Github**

- installs to `$HOME/.local/bin/plan` (make sure it's in `$PATH`)

```
git clone git@github.com:oschrenk/plan.swift.git
cd plan.swift
task install
```

**Via homebrew**

```
brew tap oschrenk/made git@github.com:oschrenk/homebrew-made
brew install oschrenk/made/plan
```
## Licensing

This project uses parts of the MIT licensed [raycast/extensions](https://github.com/raycast/extensions) project. In particular the method about generating event url from a given event, see [here](https://github.com/raycast/extensions/blob/36abdaacac9b02cbbc54dbe33f16b6c40cd23f54/extensions/menubar-calendar/swift/AppleReminders/Sources/Calendar.swift#L45)
See their license [here](https://github.com/raycast/extensions/blob/19464e5fddb25335c7b71471ea12cf5d6333bcd6/LICENSE)
