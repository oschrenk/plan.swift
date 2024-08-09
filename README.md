# README

A macOS tool to fetch calendar events as json

## Features

- returns json by default
- extracts leading emojis from event title and returns them as separate description and emoji, in addition to full title

## Usage

`plan today` Returns all events for today

```json
[
  {
    "id": "UUID:UUID",
    "calendar": {
      "id": "UUID",
      "label": "Some calendar"
    },
    "label": "full title",
    "legend": {
      "description": "title without leading emoji"
      "emoji: "🏆",
    },
    "starts_at": "",
    "starts_in": "",
    "ends_at": "",
    "ends_in": ""
 },
 ...
]
```

`plan next` Returns the current or next event within the next hour

```json
[
  {
    "id": "UUID:UUID",
    "calendar": {
      "id": "UUID",
      "label": "Some calendar"
    },
    "label": "full title",
    "legend": {
      "description": "title without leading emoji",
      "emoji: "🏆",
    },
    "starts_at": "",
    "starts_in": -20,
    "ends_at": "",
    "ends_in": 5
    "tags": ["timeblock"]
 },
 ...
]
```

`plan next --reject-tag somekeyword` Returns the current or next event within the next hour ignoring events which notes have text containing `tag:somekeyword`

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

