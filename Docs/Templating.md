# Templating

## Use cases

### Obsidian

I want to be able to inject today's schedule into my notes

```
## Schedule

- 06:00 - 07:00 👟Jogging #calendar/physical [ ](ical://...)
- 07:00 - 08:00 🍳Breakfast #calendar/personal [ ](ical://...)
- 08:00 - 10:00 🕥 [[path/to/file.md|Meeting with Jane]] #calendar/work [ ](ical://...)
```

- start and time are zero prefixed for consistent formatting
- title with emoji
- normalized calendar name with a hashtag
- clickable event URL to open Calendar app
- links to open/create files for more details when it's a meeting

Create a `template.md`  (mine lives in `~/.config/plan`)

```
## Schedule

{% for e in events %}- {{ e.schedule.start.at|format:"HH:mm"}} - {{ e.schedule.end.at|format:"HH:mm"}}{% if e.calendar.label|lowercase == "work" and e.services["meet"] %} [[Work/Meetings/{{e.schedule.start.at|format:"yyyy-MM-dd"}}-meeting|{{e.title.full}}]]{% else %}{{ e.title.full }}{% endif %} [ ]({{e.services["ical"]}}) #calendar/{{ e.calendar.label|lowercase }}
{% endfor %}
```

This is mostly standard [Stencil](https://stencil.fuller.li/en/latest/) templating.

You have access to
- an `events` array
- a custom `format` filter for date/time formatting (see cheatsheet [here](https://www.advancedswift.com/date-formatter-cheatsheet-formulas-swift/))
- a custom `slugify` filter to create a url friendly version of it

It assumes:
- that your calendar names are without spaces
- that you have Google Meet events at work

## Appendix

### Obsidian Tags

To better support Obsidian based markdown, it might valid to create template helpers to allow for valid creation of tags.

You can use any of the following characters in your tags:

- Alphabetical letters
- Numbers
- Underscore (_)
- Hyphen (-)
- Forward slash (/) for Nested tags

Tags must contain at least one non-numerical character. For example, #1984 isn't a valid tag, but #y1984 is.

Tags are case-insensitive. For example, #tag and #TAG will be treated as identical.

See also [Tag format](https://help.obsidian.md/Editing+and+formatting/Tags#Tag+format)
