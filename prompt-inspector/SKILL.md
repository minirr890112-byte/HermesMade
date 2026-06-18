---
name: prompt-inspector
description: Scan AI prompts for censorship trigger words before sending — 6 trigger categories (violence, self-harm, adult, politics, religion, drugs). Get risk levels, neutral rewrite suggestions, and uncensored system presets. Because your AI shouldn't call gardening a satanic act.
version: 1.2.0
author: minirr890112-byte
license: MIT
metadata:
  hermes:
    tags: [Prompt-Engineering, Censorship, AI-Safety, Claude, ChatGPT, CLI]
    homepage: https://github.com/minirr890112-byte/HermesMade/tree/main/prompt-inspector
---

# prompt-inspector

## Problem → Solution

**The problem**: You ask an AI a perfectly reasonable question — about gardening, history, or medicine — and it refuses. Your prompt hit a hidden trigger word in the safety filter. "I literally couldn't get an answer to a gardening question due to supposed 'violence'... Your filter thought my gardening pitchfork was a sign of satanism" — r/ChatGPT (26↑). You waste time reformulating prompts by trial and error while the clock keeps ticking.

**The solution**: One command scans your prompt before you send it. Detects trigger words across 6 categories. Tells you the risk level and suggests neutral rewrites. Saves you from the frustration spiral of "I'm sorry, I can't help with that."

## Quick Start

```bash
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=prompt-inspector

prompt-inspector "write a story about a dictator who uses propaganda"
echo "your prompt here" | prompt-inspector
cat my_prompt.txt | prompt-inspector
```

## What It Checks

| Category | Risk triggers | Examples |
|----------|--------------|----------|
| Violence | weapons, fighting, combat | "stab", "shoot", "bomb" |
| Self-harm | suicide, cutting, overdose | "kill myself", "end it all" |
| Adult | explicit content, nudity | flagged terms |
| Politics | regime, censorship, propaganda | "dictator", "oppression" |
| Religion | blasphemy, extremism | flagged terms |
| Drugs | substances, abuse, overdose | flagged terms |

## Real Output

```
$ prompt-inspector "write a story about a dictator who uses propaganda"

🔍 prompt-inspector scan results:
────────────────────────────────────────
⚠️  Found 2 potential trigger categories

🔴 Politics (CRITICAL)
   "dictator" — flagged as political violence
   💡 Rewrite: "authoritarian leader", "autocratic figure"
   
🟡 Politics (MEDIUM)
   "propaganda" — flagged as political manipulation
   💡 Rewrite: "persuasive communication", "state messaging"

📊 Risk score: 45/100
💡 Tip: Replace flagged terms with neutral alternatives above
```

## Features

- 6 censorship trigger categories
- Risk levels: critical / high / medium
- Neutral rewrite suggestions for every flagged term
- Piped input support (stdin)
- Uncensored system presets available

---
⭐ **Star this repo if your AI has ever refused a normal question**: [github.com/minirr890112-byte/HermesMade](https://github.com/minirr890112-byte/HermesMade)
