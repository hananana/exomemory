---
description: "Run monthly maintenance on the exomemory system: expire stale entries, promote frequently-referenced memories, compress old logs, and verify index integrity."
argument-hint: "[--dry-run]"
allowed-tools: [Read, Edit, Write, Bash, Glob, Grep]
---

# Exomemory Maintenance

Run this monthly to keep the memory system healthy. Performs four maintenance operations.

## Memory Location

`~/.local/share/exomemory/`

## Pre-flight Check

1. Verify `~/.local/share/exomemory/MEMORY.md` exists. If not, tell the user to run `/exomemory:memory-setup` first.
2. If `$ARGUMENTS` contains `--dry-run`, report what WOULD be done without making changes.

## Operation 1: TTL Enforcement (Forgetting)

Read `episodic/context-log.md` and check each entry's metadata:

```markdown
## YYYY-MM-DD: Title
<!-- refs: N | last_ref: YYYY-MM-DD -->
```

**Rules:**
- If `last_ref` is older than 90 days from today → move to `archive/`
- If `last_ref` is missing, use the entry's date header as fallback
- If `refs` is 0 and entry date is older than 30 days → move to `archive/`

**Moving to archive:**
1. Append the entry (header + metadata + body) to `archive/YYYY-MM.md` (grouped by month)
2. Remove the entry from `episodic/context-log.md`
3. Remove the corresponding line from `MEMORY.md`

## Operation 2: Promotion (Consolidation)

Check entries in `episodic/context-log.md` where `refs >= 3`:

For each candidate:
1. Identify the recurring pattern or rule
2. **Ask the user** whether to promote it to `semantic/frameworks.md`
3. If approved:
   - Add an entry to `semantic/frameworks.md` with the distilled rule
   - Update `MEMORY.md` index
   - Optionally archive the original episodic entry

## Operation 3: Compression

For entries in `episodic/context-log.md` older than 60 days that are NOT being archived:
- Summarize verbose entries to 2-3 bullet points
- Preserve the date header and metadata line

## Operation 4: Index Integrity

Verify `MEMORY.md` is consistent with actual files:
- Every entry in `MEMORY.md` should point to content that exists
- Every entry in memory files should have a corresponding line in `MEMORY.md`
- Remove orphaned index entries
- Add missing index entries

## Report

After all operations, summarize:
- Entries archived (count + titles)
- Entries promoted (count + titles)
- Entries compressed (count)
- Index fixes applied (count)
- Next maintenance suggested: first of next month
