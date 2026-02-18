Launch a background research agent. This command helps you start research that runs while you work on other things.

**Usage:** `/research [type] [topic]`

**Types:**
- `crypto` - Crypto/DeFi/Blockchain research
- `tech` - Technical/Development research
- `general` - General purpose research

**Arguments provided:** $ARGUMENTS

---

Based on the arguments, I will:

1. Parse the research type and topic from: "$ARGUMENTS"
2. Launch the appropriate research agent in the background using the Task tool
3. The agent will research and output JSON that can be stored with `research-store`

**To run research:**
- For crypto: Use Task tool with `/research-crypto` prompt
- For tech: Use Task tool with `/research-tech` prompt
- For general: Use Task tool with `/research-general` prompt

**Example workflow:**
```
User: /research crypto Uniswap v4 hooks
Claude: Launches background Task agent with research-crypto prompt
Agent: Researches, outputs JSON
Claude: Pipes to research-store to save findings
User: research-query uniswap  # Query findings later
```

Parse the arguments now and launch the appropriate research agent in the background.
