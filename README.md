# README

A macOS tool to fetch (the next) calendar events as json

## Features

- return JSON by default
- for emoji lovers: separate leading emojis from event title, giving you the emoji, short and full title
- ignore events based on tags e.g. `tag:example` within the event notes
- return start and end time in relative and absolute terms
- return an `ical` URL that can be used to `open $URL` to show the particular event in Calendar.app
- parse Google meet URLs from notes
- print out calendar entries with a templating engine

## Examples

### JSON

Example output in JSON

`plan next`

```json
[
  {
    "id": "9675DF46-4040-4762-A70B-6CD65DC01C36:CC525CBD-F5A3-4EBB-970E-7A0EC2D2370D",
    "calendar": {
      "id": "C5AE5024-78BD-4965-BB0D-0E43E1024368",
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
        "at": "2024-09-02T18:00:00+02:00",
        "in": 30
      },
      "end": {
        "at": "2024-09-02T19:00:00+02:00",
        "in": 90
      }
    },
    "services": [
      { "ical": "ical://ekevent/9675DF46-4040-4762-A70B-6CD65DC01C36?method=show&options=more" }
    ],
    "tags": [ "timeblock" ]
 }
]
```

### markdown

`plan today --template-path path/to/template.md`

With `template.md`:

```markdown
{% for e in events %}- {{ e.schedule.start.at|format:"HH:mm"}} - {{ e.schedule.end.at|format:"HH:mm"}}{{ e.title.full }} [ ]({{e.services["ical"]}}) #{{ e.calendar.label|lowercase }}
{% endfor %}
```

You get

```markdown
- 12:15 - 12:45 🥗 Lunch [ ](ical://ekevent/CC23ADF2-9303-42C4-A854-BE12F2081E16?method=show&options=more) #private
- 13:00 - 14:00 🕐 Meeting [ ](ical://ekevent/59856934-5D89-45A2-9C11-0E3877F1B082?method=show&options=more) #work
```

For more details, consult [Docs/Templating](Docs/Templating.md).

## Usage

### Commands

Example commands (use `plan --help` for full usage)

- `plan calendars` List available calendars
- `plan next` Returns the current or next event within the next hour
- `plan today` Returns all events for today
- `plan watch` Trigger Sketchybar event on calendar changes. See [Docs/Sketchybar](./Docs/Sketchybar.md) for more.

## Use cases

`plan` can help with your "productivity" setup. It plays very well with Sketchybar and Obsidian.
But with the default output being JSON, and the templating engine, you can easily make `plan` fit your individual needs.

### Sketchybar

You can use it with [Sketchybar](https://felixkratz.github.io/SketchyBar/) to show the next event.
For more details, consult [Docs/Sketchybar](./Docs/Sketchybar.md).

### Obsidian

You can use it with [Obsidian](https://obsidian.md/) to inject today's schedule into your notes. For more details, consult [Docs/Templating](Docs/Templating.md).

## Templating

For more details, consult [Docs/Templating](Docs/Templating.md).

## Installation

**Via GitHub**

- installs to `$HOME/.local/bin/plan` (make sure it's in `$PATH`)

```
git clone git@github.com:oschrenk/plan.swift.git
cd plan.swift
task install
```

**Via Homebrew**

```
brew tap oschrenk/made git@github.com:oschrenk/homebrew-made
brew install oschrenk/made/plan
```
