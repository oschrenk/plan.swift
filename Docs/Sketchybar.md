# Sketchybar

You can use `plan` to show the next calendar event with [Sketchybar](https://felixkratz.github.io/SketchyBar/)

# Advanced

You can use `plan watch` feature to notify Sketchybar of any changes.to

You need to configure a hook in your `~/.config/plan/config.json`. For example:

```
{
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
