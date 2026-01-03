---
description: Search conversation history
---

Search the conversation database for: $ARGUMENTS

```bash
claude-search "$ARGUMENTS"
```

If no results or you want more options:
- `claude-search --sessions "$ARGUMENTS"` - Find sessions containing this term
- `claude-search -d today "$ARGUMENTS"` - Search only today's conversations
- `claude-search -d week "$ARGUMENTS"` - Search last 7 days
- `claude-search --tools "$ARGUMENTS"` - Search tool uses
- `claude-search --stats` - Show database statistics
- `claude-search --recent` - Show recent sessions

Share the relevant results and offer to explore further or continue work on related topics.
