Show Claude Code analytics dashboard.

Run the analytics command and display the results:

```bash
claude-analytics ${ARGUMENTS:-summary}
```

Available commands:
- `summary` - Overview of all activity (default)
- `today` - Today's activity breakdown
- `week` - This week's activity
- `tokens` - Token usage analysis
- `tools` - Tool usage breakdown
- `files` - Most edited files
- `sessions` - Session activity over time
- `productivity` - Productivity metrics
- `costs` - Estimated API costs

Present the output clearly to the user.
