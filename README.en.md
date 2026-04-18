# Exomemory

> ⚠️ **DEPRECATED — this repository is no longer maintained.**
>
> Succeeded by [hananana/exomemory2](https://github.com/hananana/exomemory2).
> v2 is a ground-up redesign around [Andrej Karpathy's LLM Wiki pattern](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f). v1's tiered memory (episodic / semantic / procedural) does not map onto v2's sources / entities / concepts; a fresh start is recommended.
>
> This repository will be archived soon. Issues and PRs are not accepted.

Cognitive science-based external memory plugin for Claude Code.

Manages structured long-term knowledge through the four stages of human memory: **encoding**, **storage**, **forgetting**, and **retrieval**.

> [日本語版](./README.md)

## Features

- **3 memory types** based on cognitive science (Tulving, 1972):
  - **Episodic** — time-stamped events, discussions, discoveries (90-day TTL)
  - **Semantic** — reusable rules, frameworks, decision records (indefinite)
  - **Procedural** — work preferences, behavioral patterns (until changed)
- **R×I×R scoring** for retrieval: Recency × Importance × Relevance
- **Automatic forgetting** — TTL-based expiry and monthly maintenance (auto-checked at session start)
- **Memory promotion** — frequently-referenced episodes consolidate into semantic memory
- **SessionStart hook** — memory index is loaded automatically at session start

## Installation

### Via marketplace (recommended)

Add the marketplace to your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "extraKnownMarketplaces": {
    "exomemory": {
      "source": {
        "source": "github",
        "repo": "hananana/exomemory"
      }
    }
  }
}
```

Then install the plugin:

```
/plugin install exomemory@exomemory
```

### Update

```
/plugin update exomemory@exomemory
```

Restart Claude Code after updating to apply the changes.

### First-time setup

After installing the plugin, run:

```
/exomemory:memory-setup
```

This creates the memory directory at `~/.local/share/exomemory/`.

## Usage

### Remember

```
/exomemory:remember <what to remember>
```

Automatically classifies the content into the appropriate memory type (episodic, semantic, or procedural) and saves it.

### Recall

```
/exomemory:recall <what to recall>
```

Searches and retrieves relevant memories using R×I×R scoring. Referenced episodic memory entries have their `refs` count automatically updated.

### Monthly maintenance

Maintenance runs automatically when a session starts and more than 30 days have passed since the last run. To run manually:

```
/exomemory:memory-maintenance
```

Performs:
- TTL enforcement (archive entries older than 90 days)
- Promotion of frequently-referenced episodic memories to semantic memory
- Compression of old verbose entries
- Index integrity verification

Use `--dry-run` to preview without making changes:

```
/exomemory:memory-maintenance --dry-run
```

## Memory directory structure

```
~/.local/share/exomemory/
├── MEMORY.md                 # Index (entry point for recall)
├── episodic/
│   └── context-log.md        # Time-series events and discussions
├── semantic/
│   ├── frameworks.md          # Reusable rules and patterns
│   └── decisions.md           # Key decisions and reasoning
├── procedural/
│   └── preferences.md         # Work style and preferences
└── archive/                   # Expired entries (grouped by month)
```

## Repository structure

```
exomemory/
├── .claude-plugin/
│   └── marketplace.json        # Marketplace definition
├── plugins/
│   └── exomemory/
│       ├── .claude-plugin/
│       │   └── plugin.json     # Plugin manifest
│       ├── hooks/
│       │   └── hooks.json      # SessionStart hook definition
│       ├── hooks-handlers/
│       │   └── session-start.sh
│       ├── skills/
│       │   ├── remember/       # /exomemory:remember (save memories)
│       │   ├── recall/         # /exomemory:recall (retrieve memories)
│       │   ├── memory-maintenance/  # /exomemory:memory-maintenance
│       │   └── memory-setup/   # /exomemory:memory-setup
│       └── templates/          # Initial file templates for setup
└── README.md
```

## References

- [認知科学でAI秘書の記憶を再設計したら別人になった話](https://note.com/hatakejp/n/naae38195e8d8) — Design inspiration
- Atkinson & Shiffrin (1968) — Multi-store memory model
- Tulving (1972) — Episodic and semantic memory
- Park et al. (2023) — Generative Agents (Stanford) — R×I×R scoring

## License

MIT
