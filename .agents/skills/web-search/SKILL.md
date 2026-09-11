---
name: web-search
description: Search the web via the ketch CLI. Use when the user wants to search or find pages on a topic.
---

# Web search

When this skill is selected, execute the following command in the shell:

```bash
ketch search "<query>"
```

Use search results to find relevant sources.

Before answering, scrape the most relevant result(s) with --scrape.

You may answer from snippets alone only for a simple factual lookup where the snippet directly contains the complete answer. Done when you have enough source content to answer reliably.

## Query discipline

The backend rate limits aggressively. Budget queries, don't loop:

- Formulate the best query before running. Prefer one precise query over several fuzzy ones.
- Reuse results for follow-up questions instead of re-querying the same or similar terms.
- If a query misses, refine the terms once. Do not fire more than 2–3 queries per question.
- On a rate-limit error, stop and tell the user. Do not retry or switch providers.

## Flags

- `--json` — JSON output. Use whenever output will be parsed.
- `-l, --limit N` — max results (default 5); keep it as low as the task allows.
- `--scrape` — fetch and extract full markdown content from each result.
- `--max-chars N` — truncate markdown output to N chars.
- `--trim` — strip markdown formatting, keep content text only.
- `--minimal` — one result per line, tab-separated (url/title/snippet).
- `--cookie-file jar` / `--user-agent ua` — for `--scrape` fetches.
