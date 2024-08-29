# Templating

As a general layout, I see these variants

```
- 08:00 - 10:00 🏝️ Kotlin
- 08:00 - 10:00 🏝️ Kotlin [↗](ical://...)
- 08:00 - 10:00 🏝️ Kotlin (work)
- 08:00 - 10:00 🏝️ [[Kotlin]] [↗](ical://...) #calendar/id
- 08:00 - 10:00 [[path/to/file.md|Meeting with Jane]] [↗](ical://...)
```

- start and time are zero prefixed for consistent formatting
- title after
- event url hidden behind an arrow
- I would love to be able to create automatic links to specific files but I'm not sure how tha tlogic would work. Creating some link is easy enough, but of course I would like it to be in a specific way and that is dependent on the meeting
  - maybe I can push the logic into the event as a note?
  - it's a security risk if other people can invite you to an event with a text inside -> there might be a way to see if there is an Organizer of sorts
  - the logic would be like
  - if calendar == "Work"
    and tag = "Meeting"
    then path => <VAULT>/20 Areas/Work/Meetings/YYYY-mm-dd-slug
  - how to generate slug?


```
- {{start:"HH:mm"}} - {{end:"HH:mm"}}{{title}}[↗
]({{eventURL}})

The wikilink links to a page in case of meetings
ideally that meeting page is at a certain location already
- like 1:1, therapy, etc
- they have a date
- ideally they are created using a template
- maybe use "tags" in the notes
- the arrow points to the calendar entry


## Mustache

```
- {{start:"HH:mm"}} - {{end:"HH:mm"}}{{title}} [↗]({{url}}) #calendar/{{calendar:id}}
- {{start:"HH:mm"}} - {{end:"HH:mm"}}{{title}} [↗]({{url}}) #calendar/{{calendar:uuid}}
- {{start:"HH:mm"}} - {{end:"HH:mm"}}{{title}} [↗]({{url}}) ({{calendar:title.lowercased}})

```

## Stencil

```
## Schedule

{% for e in events %}
- {{ e.start.at|format:"HH:mm" }} - {{ e.end.at|format:"HH:mm" }}{{e.title.full}} [↗]({{e.services["ical"].url}}) ({{e.calendar.title|lowercased}})
{% endfor %}
```
