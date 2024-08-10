# README

A macOS tool to fetch (the next) calendar events as json

## Features

- returns JSON by default
- separates leading emojis from event title, and gives you the emoji, short and full title
- rejects events based on tags `tag:example` within the event notes
- start and end time in relative and absolute terms

## Usage

Example commands (use `plan --help` for full usage)

- `plan today` Returns all events for today
- `plan next` Returns the current or next event within the next hour
- `plan next --reject-tag somekeyword` Returns the current or next event within the next hour ignoring events which notes have text containing `tag:somekeyword`
- `plan calendars` List available calendars

Example output

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

