---
name: web-scraping
description: Scrape one or more URLs to clean markdown via the ketch CLI. Use when the user wants a web page fetched, scraped, or converted to markdown.
---

# Web scraping

When this skill is selected, execute the following command in the shell:

```bash
ketch scrape "<input>"
```

`ketch scrape` fetches URLs and prints the main content as clean markdown.

Input is auto-detected: multiple URL args, a quoted JSON array `'["u1","u2"]'`, a file of URLs, or a stdin pipe.

Done when the markdown body contains the page's main content — plain output opens with a `---` header block (`url`, `title`, `words`) and the `words` count should be non-trivial. A JS-heavy page that returns an empty shell needs a re-run with `--force-browser`.

## Flags

- `--json` — JSON object (single URL) or array (many). Use whenever output will be parsed.
- `--select "CSS"` — extract specific elements instead of the main content.
- `--max-chars N` — truncate markdown to N chars.
- `--trim` — plain text, markdown formatting stripped.
- `--raw` — raw HTML instead of markdown.
- `--force-browser` — render via headless Chromium; use when a JS-heavy page comes back empty.
- `--no-cache` — re-fetch, bypassing the page cache.
- `--no-llms-txt` — bare domains resolve `/llms.txt` automatically; this flag fetches the actual homepage.
- `--cookie-file jar` / `--user-agent ua` — for fetches needing cookies or a specific UA.
- `--concurrency N` — batch parallelism (default 5).

If `--force-browser` reports a missing browser, run `ketch browser install` once, then re-run the scrape.
