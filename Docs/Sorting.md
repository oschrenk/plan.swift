# Sorting

You can control sorting of the output by using:
```
plan today --sort-by schedule.start.in
plan today --sort-by schedule.start.in:desc
plan today --sort-by schedule.start.in:asc,calendar.id
```

The default sorting is:

`schedule.start.in:asc`

Most fields of the JSON can be used for sorting

- `id`
- `calendar.id`
- `calendar.type`
- `calendar.label`
- `calendar.color`
- `title.full`
- `title.label`
- `title.icon`
- `schedule.start.at`
- `schedule.start.in`
- `schedule.end.at`
- `schedule.end.in`
- `schedule.all_day`
- `location`
- `meeting.organizer`

You can't sort on fields that have multiple values, such as `attendees`, `services`, or `tags`

Sorting on `id` based fields might not be useful to sort on first glance, but can create consistency for results.
