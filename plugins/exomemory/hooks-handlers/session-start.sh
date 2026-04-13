#!/usr/bin/env bash

# Exomemory — SessionStart hook
# Injects MEMORY.md index as additionalContext if the memory directory exists.

MEMORY_DIR="$HOME/.local/share/exomemory"
MEMORY_INDEX="$MEMORY_DIR/MEMORY.md"

if [ -f "$MEMORY_INDEX" ]; then
  memory_content=$(python3 -c "
import sys, json
with open(sys.argv[1]) as f:
    print(json.dumps(f.read())[1:-1])
" "$MEMORY_INDEX")

  cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[Exomemory] Memory index loaded from ${MEMORY_INDEX}:\n${memory_content}\n\nMemory data is stored at ${MEMORY_DIR}/. Use Read to access individual files as needed. When you reference an episodic memory entry, update its refs count and last_ref date."
  }
}
EOF
else
  cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[Exomemory] Memory directory is not initialized. Run /exomemory:memory-setup to set up the memory system."
  }
}
EOF
fi

exit 0
