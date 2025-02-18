# Config

**Example**

This config will
- add a "🪷" icon to every calendar item matching the `Yoga` regex
- fire an `calendar_changed` event for sketchybar if events change
```
{
  "iconize": [
    {
      "field": "title.label",
      "regex": "Yoga",
      "icon": "🪷"
    }
  ],
  "hooks": [
    {
      "path": "/opt/homebrew/bin/sketchybar",
      "args": [
        "--trigger",
        "calendar_changed"
      ]
    }
  ]
}
```
