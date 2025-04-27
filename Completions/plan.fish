# Commands
complete -c plan -f
complete -c plan -n __fish_use_subcommand -a calendars -d "List available calendars" -r
complete -c plan -n __fish_use_subcommand -a hours -d "List hours per event on ..."
complete -c plan -n __fish_use_subcommand -a next -d "List next event"
complete -c plan -n __fish_use_subcommand -a on -d "List events on ..."
complete -c plan -n __fish_use_subcommand -a today -d "List today's events"

set -l _all_subcommands calendars hours next on today
set -l _event_subcommands hours next on today

# all
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l help -d 'Print help'
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l debug -d 'Print debug statements'

# calendars subcommands
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l select-calendar-ids -d 'Select calendar(s) with id'
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l ignore-calendar-ids -d 'Ignore calendar(s) with id'
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l select-calendar-labels -d 'Select calendar(s) with label'
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l ignore-calendar-labels -d 'Ignore calendar(s) with label'
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l select-calendar-sources -d 'Select calendar(s) with source'
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l ignore-calendar-sources -d 'Ignore calendar(s) with source'
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l select-calendar-types -d 'Select calendar(s) with type'
complete -c plan -n "__fish_seen_subcommand_from $_all_subcommands" -l ignore-calendar-types -d 'Ignore calendar(s) with type'

# event subcommands
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l select-all-day-events -d 'Select only all-day events'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l ignore-all-day-events -d 'Ignore only all-day events'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l select-title -d 'Select titles matching the given pattern'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l ignore-title -d 'Ignore titles matching the given pattern'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l select-tags -d 'Select events which notes contain tag'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l ignore-tags -d 'Ignore events which notes contain tag'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l select-services -d 'Select events which services contain service'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l ignore-services -d 'Ignore events which services contain service'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l min-num-attendees -d 'Minimum (inclusive) number of attendees'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l max-num-attendees -d 'Maximum (inclusive) number of attendees'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l min-duration -d 'Minimum (inclusive) length (in m) of event'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l max-duration -d 'Maximum (inclusive) length (in m) of event'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l template-path -d 'Template path'
complete -c plan -n "__fish_seen_subcommand_from $_event_subcommands" -l sort-by -d 'Sort by field'

# next only:
complete -c plan -n '__fish_seen_subcommand_from next' -l within -d 'Fetch events within'
