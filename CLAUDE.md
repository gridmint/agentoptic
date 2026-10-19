# agentoptic

TypeScript CLI, Node 22+, SQLite. Biome 2 for lint/format, do not disable rules. No `any`.
Conventional commits: feat/fix/chore/docs.
Run `bun run typecheck && bun run lint && bun test` before committing.
Schema source of truth: `src/db/schema.sql`. Message texts and tool outputs are never stored in the DB.
Planning docs live outside the repo in `../../docs/`; read `architecture-draft.md` before changing the schema.
