---
name: sub-agent
description: "Spawn an isolated pi sub-agent via pi --print for self-contained tasks like code review or context gathering."
---

# Sub-agent

pi has no built-in sub-agent tool. To spawn one, run pi itself from bash in non-interactive mode.

## When to use it

- Code review or analysis that would flood the current context with tool output.
- Context gathering: read many files and produce a small artifact the current or a fresh session can use instead of the raw output.
- A second opinion, or a task the user wants run on a different model or thinking level.
- Any bounded task with a self-contained prompt: the sub-agent can produce a useful result from the prompt and the file system alone.

## When not to use it

- Parallel implementation of features or refactors. Each sub-agent diverges from the others and the codebase degrades. Do one thing at a time in the current session, or run a second opinion and decide.
- Work that needs interactive steering. The user cannot steer a sub-agent, so long work (implementing a feature, designing an API) belongs in a dedicated interactive session, not a sub-agent.
- Do not reach for a sub-agent as a mid-session context-saving trick. If a task needs more context, gather it into an artifact first (see "Context gathering").

## How to spawn a sub-agent

1. Write a self-contained prompt. The sub-agent cannot see this session: include file paths, git references, review or analysis criteria, and the expected output format.
2. Choose flags:
   - Match the current session by default: read `PI_PROVIDER`, `PI_MODEL`, and `PI_REASONING_LEVEL` from the environment and pass `--provider "$PI_PROVIDER" --model "$PI_MODEL:$PI_REASONING_LEVEL"`. The model pattern supports a `:<thinking>` suffix (off, minimal, low, medium, high, xhigh, max). Override the provider, model, or level only when the user or task specifies otherwise.
   - Default to --no-session. Use --session <path> only when the user wants the sub-agent session saved or resumable.
3. Write the prompt to /tmp/pi-prompt-<task>.md first (with the write tool or a single-quoted heredoc) so embedded quotes and newlines in the prompt cannot break the shell call.
4. Run from the project root and capture the output:

   pi --print "$(cat /tmp/pi-prompt-<task>.md)" [flags] > /tmp/pi-sub-agent-<task>.md 2>&1

5. Read the output file.
6. Report the findings in the current session. Do not re-verify by re-reading the target files unless a finding is surprising or the output is incomplete. The prompt and output files may be deleted once the findings are reported.

## Watching or steering the sub-agent

Full observability of a sub-agent's internal conversation is not available from a --print run, only of its output. When the user wants to observe or steer the run directly, launch it interactively inside tmux:

tmux new-session -d -s pi-sub-agent-<task> 'pi "$(cat /tmp/pi-prompt-<task>.md)" [flags]'

Then attach with tmux attach -t pi-sub-agent-<task>. Use this for long-running tasks or when the user wants to watch or give a one-off nudge — it does not turn the sub-agent into an interactive session; work needing continuous steering still belongs in a dedicated session.

## Code review and second opinions

For a review or a second opinion, give the sub-agent the scope, the criteria, and a length-bound report:

"Run a code review of <scope: file paths or a diff range such as `git diff main...HEAD`> against <criteria: correctness, error handling, test coverage>. Report findings by severity with `file:line` references, and what looks good. Under 300 words per finding."

The length bound matters: the report is the only thing that comes back into the current session, so an unbounded report defeats the point of spawning the sub-agent.

## Context gathering

For context gathering, instruct the sub-agent to read files in full and write a summary artifact:

"Read files A, B, C in full and trace <concept>. Write a summary to <artifact path> covering what a fresh session needs to <implement X / fix Y>."

Then feed the artifact's contents into the current session (or a fresh one) as context, instead of re-reading the source files. Keep the artifact in the repo or a notes file so it serves the next related task too.

## Limitations

- The sub-agent sees the same working directory and files but nothing else: no memory of this session, no way to ask the user questions.
- If a run comes back wrong or short on context, do not attempt to debug from inside the sub-agent: refine the prompt — or, if the failure is a context gap, the gathered artifact (a sub-agent reads the same files the current session can) — and rerun.
