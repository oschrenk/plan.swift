# Usecases

# Sum hours

Sum hours spent

```
plan on --select-pattern-title "Work" "next monday" | jq .[].schedule.duration | awk '{s+=$1} END {print s}' | xargs -I % echo "scale=2; % / 60" | bc
```
