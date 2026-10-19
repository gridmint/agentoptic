#!/usr/bin/env node
// AgentOptic CLI entry point. Commands are defined in docs/architecture-draft.md (section 2).
// Week-2 prototype: task start / task close. Nothing is implemented until the week-1 go decision.

const HELP = `agentoptic — per-task cost and outcome ledger for multi-agent coding sessions

Usage:
  agentoptic task start <title>   create a task and remember cwd, branch and HEAD
  agentoptic task close [id]      link sessions, run tests, collect diff stats, print the ledger
  agentoptic task status [id]     show linked sessions so far

Status: scaffold only. See docs/plan.md for the go/no-go gate before implementation.`;

const [, , ...args] = process.argv;
if (args.length === 0 || args[0] === "--help" || args[0] === "-h") {
  console.log(HELP);
  process.exit(0);
}
console.error(`agentoptic: command "${args.join(" ")}" is not implemented yet (scaffold).`);
process.exit(2);
