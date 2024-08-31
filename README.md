# README

A macOS tool to fetch (the next) calendar events as json

## Features

- return JSON by default
- for the emoji lovers: separate leading emojis from event title, giving you the emoji, short and full title
- ignore events based on tags eg. `tag:example` within the event notes
- return start and end time in relative and absolute terms
- return an `ical` URL that can be used to `open $URL` to show the particular event in Calendar.app
- parse Google meet urls from notes
- print out calendar entries with a templating engine

## Configuration

### Sketchybar

If you intend to use the `plan watch` feature to monitor the `~/Library/Calendars` directory to fire Sketchybar events, you need to give `/opt/homebrew/bin/plan` "Full Disk access".

macOS protects files in `~/Library/` from potential malicious access.

You can give `plan` access, by opening "System Settings > Privacy & Security > Full Disk Access", Click on the "+" icon, and navigate to `/opt/homebrew/bin/plan` (Cmd+Shift+G in the Finder let's you navigate more directly by typing)

This is different from the access to the actual "Calendar" app. macOS will actually prompt you for that.

## Usage

### Basic

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
      "color": "#E195DA",
      "label": "Some calendar",
      "type": "caldav"
    },
    "title": {
      "full": "🏆 Release plan",
      "description": "Release plan",
      "icon": "🏆"
    },
    "schedule": {
      "start": {
        "at": "2024-08-09T18:00:00+02:00",
        "in": 30
      },
      "end": {
        "at": "2024-08-09T17:00:00+02:00",
        "in": 90
      }
    },
    "services": [
      { "ical": "ical://ekevent/93109B45-776C-43AA-A6E9-A04606EF9F1C?method=show&options=more" }
    ],
    "tags": [ "foo" ]
 }
]
```

### Templating

You can define a template using the [Stencil](https://stencil.fuller.li/) templating language to print events the way you like it.

Here is a (complicated looking) markdown based template
```
{% for e in events %}- {{ e.schedule.start.at|format:"HH:mm"}} - {{ e.schedule.end.at|format:"HH:mm"}}{% if e.calendar.label|lowercase == "work" and e.services["meet"] %} [[Work/Meetings/{{e.schedule.start.at|format:"yyyy-MM-dd"}}-meeting|{{e.title.full}}]]{% else %}{{ e.title.full }}{% endif %} [📅]({{e.services["ical"]}}) #calendar/{{ e.calendar.label|lowercase }}
{% endfor %}
```

that creates a markdown like

```
- 12:15 - 12:45🥗 Lunch [📅](ical://ekevent/CC23ADF2-9303-42C4-A854-BE12F2081E16?method=show&options=more) #calendar/private
- 13:00 - 14:00 [[Work/Meetings/2024-08-31-meeting|🕐 Meeting]] [📅](ical://ekevent/59856934-5D89-45A2-9C11-0E3877F1B082?method=show&options=more) #calendar/oschrenk
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
