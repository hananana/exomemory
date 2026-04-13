---
description: "Initialize the exomemory directory structure. Run this once to set up the memory system."
argument-hint: ""
allowed-tools: [Read, Bash, Write, Glob]
---

# Exomemory Setup

Initialize the external memory system at `~/.local/share/exomemory/`.

## Steps

### 1. Check if already initialized

```bash
if [ -d "$HOME/.local/share/exomemory" ]; then
  echo "EXISTS"
else
  echo "NOT_FOUND"
fi
```

If `EXISTS`, ask the user whether to reset or abort. Do NOT overwrite without confirmation.

### 2. Copy templates

If proceeding with setup:

```bash
mkdir -p "$HOME/.local/share"
cp -r "${CLAUDE_PLUGIN_ROOT}/templates" "$HOME/.local/share/exomemory"
```

### 3. Verify

List the created files to confirm:

```bash
find "$HOME/.local/share/exomemory" -type f
```

### 4. Report

Tell the user:
- Memory system initialized at `~/.local/share/exomemory/`
- MEMORY.md is the index — entries will be added as you work
- Run `/exomemory:memory-maintenance` monthly to clean up stale entries
