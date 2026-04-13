---
description: "Save a memory to the exomemory system. Classifies and stores the given information into the appropriate memory type."
argument-hint: <what to remember>
allowed-tools: [Read, Edit, Write, Glob]
---

# Exomemory Remember

Save the user's input to the exomemory system at `~/.local/share/exomemory/`.

## Steps

### 1. Read current state

Read `~/.local/share/exomemory/MEMORY.md` to understand the current index.

### 2. Classify the memory

Determine the best memory type based on the content of `$ARGUMENTS`:

| Content type | Memory type | File |
|---|---|---|
| Event, discussion, discovery, what happened today | Episodic | `episodic/context-log.md` |
| Decision and its reasoning, why something was chosen | Semantic (decision) | `semantic/decisions.md` |
| Reusable rule, pattern, framework, lesson learned | Semantic (framework) | `semantic/frameworks.md` |
| User preference, work style, behavioral pattern | Procedural | `procedural/preferences.md` |

If ambiguous, ask the user which type to use.

### 3. Save the memory

**For episodic memory** — append to `episodic/context-log.md`:

```markdown
## YYYY-MM-DD: Title
<!-- refs: 0 | last_ref: YYYY-MM-DD -->
- Description
```

**For semantic (decision)** — append to `semantic/decisions.md`:

```markdown
## YYYY-MM-DD: Decision Title
- **Context**: Why this decision was needed
- **Options considered**: What alternatives existed
- **Decision**: What was chosen
- **Reasoning**: Why
```

**For semantic (framework)** — append to `semantic/frameworks.md` under an appropriate heading.

**For procedural** — add to the appropriate category in `procedural/preferences.md`.

### 4. Update the index

Add a line to `MEMORY.md` under the appropriate section. Format:

```markdown
- [Title](path/to/file.md) — one-line summary [tags]
```

### 5. Report

Tell the user:
- What was saved
- Which memory type and file
- The index entry added
