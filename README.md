# AgentOptic

Per-task cost and outcome ledger for multi-agent coding sessions. Local-first CLI for macOS and Linux.

One task is often spread across Claude Code, Codex and their subagents. AgentOptic links every session
back to the task and prints one ledger: tokens and wall-clock time per agent, test verdict, diff size,
manual edits and rework. It does not replace session viewers or token dashboards; it sits on top of them.

**Status: scaffold.** No functionality yet. Implementation starts after the week-1 go/no-go gate
described in the planning docs (kept outside this repository).

## Planned commands

```
agentoptic task start <title>
agentoptic task close [id]
agentoptic task status [id]
```

## Stack

TypeScript, Node 22+, SQLite, no UI. Biome for lint and format.

```
bun install
bun run dev -- --help
bun run typecheck && bun run lint
```

## License

MIT
