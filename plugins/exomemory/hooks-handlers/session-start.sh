#!/usr/bin/env bash

# Exomemory — SessionStart hook
# Injects MEMORY.md index as additionalContext if the memory directory exists.
# Also checks if monthly maintenance is overdue.

MEMORY_DIR="$HOME/.local/share/exomemory"
MEMORY_INDEX="$MEMORY_DIR/MEMORY.md"
LAST_MAINTENANCE="$MEMORY_DIR/.last_maintenance"

if [ -f "$MEMORY_INDEX" ]; then
  memory_content=$(python3 -c "
import sys, json
with open(sys.argv[1]) as f:
    print(json.dumps(f.read())[1:-1])
" "$MEMORY_INDEX")

  # Check if maintenance is overdue (>30 days)
  maintenance_notice=""
  if [ -f "$LAST_MAINTENANCE" ]; then
    last_ts=$(cat "$LAST_MAINTENANCE")
    now_ts=$(date +%s)
    days_since=$(( (now_ts - last_ts) / 86400 ))
    if [ "$days_since" -ge 30 ]; then
      maintenance_notice="\\n\\n[Exomemory] Monthly maintenance is overdue (last run: ${days_since} days ago). Run /exomemory:memory-maintenance now."
    fi
  else
    maintenance_notice="\\n\\n[Exomemory] Monthly maintenance has never been run. Run /exomemory:memory-maintenance now."
  fi

  cat << EOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "[Exomemory] Memory index loaded from ${MEMORY_INDEX}:\n${memory_content}\n\nMemory data is stored at ${MEMORY_DIR}/. Use Read to access individual files as needed. When you reference an episodic memory entry, update its refs count and last_ref date.${maintenance_notice}"
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
