-- AgentOptic prototype schema. Source of truth: docs/architecture-draft.md (section 3).
-- Message texts and tool outputs are never stored; only paths and offsets into the agents' own JSONL files.

PRAGMA journal_mode = WAL;
PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS tasks (
  id            TEXT PRIMARY KEY,
  title         TEXT NOT NULL,
  repo_root     TEXT,
  worktree_path TEXT NOT NULL,
  branch        TEXT,
  base_commit   TEXT,
  started_at    INTEGER NOT NULL,
  closed_at     INTEGER,
  status        TEXT NOT NULL CHECK (status IN ('open', 'closed'))
);

CREATE TABLE IF NOT EXISTS sessions (
  id                TEXT PRIMARY KEY,
  agent             TEXT NOT NULL CHECK (agent IN ('claude-code', 'codex')),
  source_path       TEXT NOT NULL,
  cwd               TEXT,
  parent_session_id TEXT REFERENCES sessions(id),
  model             TEXT,
  first_event_at    INTEGER NOT NULL,
  last_event_at     INTEGER NOT NULL,
  last_offset       INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS task_sessions (
  task_id     TEXT NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
  session_id  TEXT NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  link_method TEXT NOT NULL CHECK (link_method IN ('explicit', 'env', 'parent', 'cwd_time', 'time')),
  confidence  TEXT NOT NULL CHECK (confidence IN ('high', 'medium', 'low')),
  excluded    INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (task_id, session_id)
);

CREATE TABLE IF NOT EXISTS events (
  id                 INTEGER PRIMARY KEY,
  session_id         TEXT NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  ts                 INTEGER NOT NULL,
  kind               TEXT NOT NULL CHECK (kind IN (
                       'user_message', 'assistant_message', 'tool_call', 'tool_result',
                       'subagent_start', 'subagent_end')),
  tool_name          TEXT,
  duration_ms        INTEGER,
  input_tokens       INTEGER,
  output_tokens      INTEGER,
  cache_read_tokens  INTEGER,
  cache_write_tokens INTEGER,
  value_kind         TEXT NOT NULL DEFAULT 'measured' CHECK (value_kind IN ('measured', 'estimated')),
  source_offset      INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS events_session_ts ON events(session_id, ts);

CREATE TABLE IF NOT EXISTS outcomes (
  task_id          TEXT PRIMARY KEY REFERENCES tasks(id) ON DELETE CASCADE,
  test_command     TEXT,
  test_exit_code   INTEGER,
  test_duration_ms INTEGER,
  test_summary     TEXT,
  files_changed    INTEGER NOT NULL DEFAULT 0,
  lines_added      INTEGER NOT NULL DEFAULT 0,
  lines_removed    INTEGER NOT NULL DEFAULT 0,
  commits          INTEGER NOT NULL DEFAULT 0,
  manual_edits     INTEGER NOT NULL DEFAULT 0,
  user_messages    INTEGER NOT NULL DEFAULT 0
);
