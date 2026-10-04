---
name: sub-agent
description: "Spawn an isolated pi sub-agent via pi --print inside a tmux session for self-contained tasks like code review or context gathering."
---

# Sub-agent

pi has no built-in sub-agent tool. To spawn one, run pi itself in non-interactive mode inside a detached tmux session; every run goes through tmux so it stays visible, killable, and survives the launching bash call.

## When to use it

- Code review or analysis that would flood the current context with tool output.
- Context gathering: read many files and produce a small artifact the current or a fresh session can use instead of the raw output.
- A second opinion, or a task the user wants run on a different model or thinking level.
- Any bounded task with a self-contained prompt: the sub-agent can produce a useful result from the prompt and the file system alone.

## When not to use it

- Parallel implementation of features or refactors. Each sub-agent diverges from the others and the codebase degrades. Do one thing at a time in the current session, or run a second opinion and decide.
- Work that needs interactive steering. The user cannot steer a sub-agent, so long work (implementing a feature, designing an API) belongs in a dedicated interactive session, not a sub-agent.
- Do not reach for a sub-agent as a mid-session context-saving trick. If a task needs more context, gather it into an artifact first.

## How to spawn a sub-agent

1. Write a self-contained prompt. The sub-agent cannot see this session: include file paths, git references, review or analysis criteria, and the expected output format.
2. Choose flags:
   - Match the current session by default: read `PI_PROVIDER`, `PI_MODEL` from the environment and pass `--provider "$PI_PROVIDER" --model "$PI_MODEL"`. The model pattern supports a `thinking` param (off, minimal, low, medium, high, xhigh, max). Choose reasoning based on the task.
3. Pick a random numeric suffix and name the files .pi/pi-prompt-<task>-<n>.md and .pi/pi-sub-agent-<task>-<n>.md, so two runs of the same task do not clobber each other's files. Write the prompt to the prompt file first (with the write tool or a single-quoted heredoc) so embedded quotes and newlines in the prompt cannot break the shell call.
4. Before launching, display the attach command to the user, on its own, with no additional text or explanation:

   tmux attach -t pi-sub-agent-<task>-<n>

5. Launch from the project root inside a detached tmux session. The single quotes are for the outer shell only: tmux runs the command string in its own shell, so `$(cat ...)` expands there, at launch time:

   tmux new-session -d -s pi-sub-agent-<task>-<n> 'pi --print --provider "$PI_PROVIDER" --model "$PI_MODEL" --thinking "<level>" --no-session "$(cat .pi/pi-prompt-<task>-<n>.md)" > .pi/pi-sub-agent-<task>-<n>.md 2>&1'

6. Wait for the run to finish. Poll in a single bash call with a timeout (~10 minutes for a review-sized task):

   for i in $(seq 1 300); do tmux has-session -t pi-sub-agent-<task>-<n> 2>/dev/null || break; sleep 2; done

7. Read the output file. If it is empty or the session is still alive, the run failed or is stuck: check with `tmux capture-pane -t pi-sub-agent-<task>-<n> -p` what the sub-agent is doing, then kill it with `tmux kill-session -t pi-sub-agent-<task>-<n>` and rerun with a refined prompt.
8. Report the findings in the current session. Do not re-verify by re-reading the target files unless a finding is surprising or the output is incomplete. Kill the session if it is still around (`tmux kill-session -t pi-sub-agent-<task>-<n>`) and delete the prompt and output files once the findings are reported.

Run several sub-agents at once only for read-only tasks — fire the bash calls in one codemode call. Never run tasks in parallel that write files.

## Limitations

- The sub-agent sees the same working directory and files as this session, and nothing else.
- If a run comes back wrong or short on context, do not attempt to debug from inside the sub-agent: the fix is prompt-side.
