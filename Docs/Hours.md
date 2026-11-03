# Hours

Sum hours per day and title

```
plan hours                                     # current week
plan hours --weeks-ago 2                       # the week two weeks ago
plan hours --select-title "Work" "next monday" # a single day
```

Every day of the period prints, also without events.
An event counts in full on the day it starts.

```
2026-10-19 Mon   5.00
  🕐 Timewax     5.00
2026-10-20 Tue   0.00
Total            5.00
```

Use `--json` for machine-readable output.

```json
{
  "days" : [
    {
      "date" : "2026-10-19",
      "titles" : {
        "🕐 Timewax" : 5
      },
      "total" : 5
    },
    {
      "date" : "2026-10-20",
      "titles" : {},
      "total" : 0
    }
  ],
  "total" : 5
}
```
