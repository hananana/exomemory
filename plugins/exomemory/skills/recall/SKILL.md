---
description: "Retrieve relevant memories from the exomemory system using R×I×R scoring."
argument-hint: <what to recall>
allowed-tools: [Read, Edit, Glob, Grep]
---

# Exomemory Recall

Retrieve memories relevant to `$ARGUMENTS` from the exomemory system at `~/.local/share/exomemory/`.

## Memory Types

| Type | File | Purpose | TTL |
|---|---|---|---|
| Episodic | `episodic/context-log.md` | Events, discussions, discoveries (dated) | 90 days from last_ref |
| Semantic (rules) | `semantic/frameworks.md` | Reusable rules, patterns, frameworks | Indefinite |
| Semantic (decisions) | `semantic/decisions.md` | Key decisions and reasoning | Indefinite |
| Procedural | `procedural/preferences.md` | Work style, preferences | Until changed |

## Retrieval: R×I×R Scoring

Score each memory entry:

```
Score(memory) = Recency × Importance × Relevance
```

### Recency (freshness — stepped decay)

| Period | Score |
|---|---|
| Within 1 week | 1.0 |
| 1–2 weeks | 0.8 |
| 2 weeks – 1 month | 0.5 |
| Over 1 month | 0.3 |
| Over 3 months | 0.1 (deletion candidate) |

### Importance (by storage location)

| Location | Score |
|---|---|
| MEMORY.md top ranking (High Frequency) | 1.0 |
| semantic/frameworks.md or semantic/decisions.md | 0.8 |
| episodic/context-log.md | 0.5 |
| archive/ | 0.1 |

### Relevance (contextual match)

Judge by comparing `$ARGUMENTS` against MEMORY.md index entries (title + tags + summary). No vector DB needed — read the index and use your judgment.

## Retrieval Process

1. **Scan** — Read `~/.local/share/exomemory/MEMORY.md` to get the full index
2. **Score** — Apply R×I×R to identify the most relevant entries
3. **Load** — Read only the files/sections needed

## Updating refs on access

When you read an episodic memory entry:
1. Increment `refs` by 1
2. Update `last_ref` to today's date
3. Use Edit tool to apply the change

This metadata drives TTL resets and promotion decisions in maintenance.

## Report

Present the retrieved memories to the user, organized by relevance. If nothing relevant is found, say so.
