# prompt-inspector

Scan AI prompts for censorship trigger words, get rewrite suggestions, and uncensored system presets.

> *"I literally couldn't get an answer to a gardening question due to supposed 'violence'... Your filter thought my gardening pitchfork was a sign of satanism."* — r/ChatGPT (26↑)

## Install

```bash
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=prompt-inspector
```

Or from local:
```bash
cd HermesMade/prompt-inspector && pip install .
```

## Usage

```bash
# Scan a prompt
prompt-inspector "write a story about a dictator who uses propaganda"

# Pipe from stdin
echo "your prompt here" | prompt-inspector

# Pipe from file
cat my_prompt.txt | prompt-inspector
```

## What it checks

6 trigger categories: violence, self-harm, adult, politics, religion, drugs

Each hit gets:
- Risk level (critical/high/medium)
- Neutral rewrite alternatives
- Academic/educational framing strategies

## Unblock with local LLMs

Includes ready-to-copy uncensored system prompts for Gemma, DeepSeek, and Llama.

## From Reddit

Part of [HermesMade](https://github.com/minirr890112-byte/HermesMade) — tools built from real Reddit pain points.
