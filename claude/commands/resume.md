---
description: View recent work and continue where we left off
---

Please help me resume from my previous work session.

First, query the conversation database for recent context:

```bash
# Show recent sessions
claude-search --recent 2>/dev/null | head -40

# Search for any pending/incomplete tasks
sqlite3 ~/.claude/conversations.db "
SELECT substr(content_text, 1, 200) as task
FROM messages_fts
JOIN messages m ON messages_fts.rowid = m.rowid
WHERE messages_fts MATCH 'pending OR incomplete OR TODO'
ORDER BY m.timestamp DESC
LIMIT 5;
" 2>/dev/null
```

Then read my system knowledge base (~/.claude/CLAUDE.md) and show me:

1. **Active Tasks** - What I was working on
2. **Incomplete/Interrupted Work** - What needs to be finished
3. **Recent Work Session** - What we did last time
4. **Known Issues** - Any problems to be aware of

Ask me what I'd like to continue working on, offering:
- Completing any incomplete/interrupted tasks
- Addressing any known issues
- Starting something new

Be ready to continue exactly where we left off with full context of my system and previous work.
