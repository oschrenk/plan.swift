# Obsidian

You can setup [Obsidian](https://obsidian.md/) to insert today's schedule into your notes.

## Preparation

You need a valid template.

We assume for now that it will live at `~/.config/plan/obsidian.md`

## Basic

If you feel confident with the Terminal, you can

```
plan today --template-path ~/.config/plan/obsidian.md | pbcopy
```

Given a valid template, this will copy the output to your clipboard.
You can then paste it into your Obsidian note.

## Advanced

- Install, and enable the [Shell Commands](https://github.com/Taitava/obsidian-shellcommands) plugin
- Open "Settings > Community Plugins > Shell Commands" and choose "New Shell Command"
- enter `plan today --template-path ~/.config/plan/obsidian.md` for the command
- it is recommended to give the command a memorable "Alias". Click on the little gear icon to do so
- now you can open the command palette and search for the Alias you just created
