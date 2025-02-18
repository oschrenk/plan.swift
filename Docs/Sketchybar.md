# Sketchybar

You can use `plan` to show the next calendar event with [Sketchybar](https://felixkratz.github.io/SketchyBar/)

## Lua

Put this file in `./items/Calendar`

```lua
local sbar = require("sketchybar")

local Calendar = {}
function Calendar.new()
  local self = {}

  local icons = {
    default: ""
  }

  self.add = function(position)
    local calendar = sbar.add("item", {
      position = position,
      update_freq = 120,
      icon = icons.default,
    })

    local update = function()
      sbar.exec("/opt/homebrew/bin/plan next --ignore-tags timeblock --ignore-all-day-events", function(json)
        local event = json[1]
        if event ~= nil then
          local icon = strings.TrimToNil(event.title.icon) or icons.default
          local label = event.title.label
          local suffix = ""

          if event["schedule"]["start"]["in"] < 0 then
            suffix = ", " .. event["schedule"]["end"]["in"] .. "m" .. " left"
          else
            suffix = " in " .. event["schedule"]["start"]["in"] .. "m"
          end
          calendar:set({
            icon = {
              string = icon,
              drawing = true,
            },
            label = {
              string = label .. suffix,
              drawing = true,
            },
            drawing = true,
          })

          local url = ""
          for type, u in pairs(event["services"]) do
            if type == "ical" then
              url = u
            end
          end
          calendar:subscribe("mouse.clicked", function(_)
            sbar.exec("open '" .. url .. "'")
          end)
        else
          calendar:set({
            icon = {
              string = icons.default,
              drawing = true,
            },
            label = {
              drawing = false,
            },
            drawing = true,
          })
        end
      end)
    end

    calendar:subscribe({ "forced", "routine", "system_woke"  }, function(_)
      focus.handler(update)
    end)
  end

  return self
end

return Calendar

```

Include it from `sketchybarrc`

```
require("items.calendar").new().add("right")
```

# Advanced

> [!warn] This feature is currently under review. It works when run in a terminal but not when run as a service.

You can use `plan watch` feature to notify Sketchybar of any changes.

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
