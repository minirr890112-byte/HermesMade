# code-inspector

Scan AI-generated code for common issues and get a production-readiness score.

> *"everything seemed fine until you inspected the edge cases, it missed the core logic"* — r/webdev (27↑)
> *"Broke entire site because you let loose Claude? Triple rate"* — r/webdev (21↑)

## Install

```bash
pip install git+https://github.com/minirr890112-byte/HermesMade.git#subdirectory=code-inspector
```

## Usage

```bash
code-inspector app.py           # scan a file
cat app.py | code-inspector     # scan from pipe
```

## What it checks

| Check | Severity | Example |
|-------|----------|---------|
| Hardcoded secrets | 🔴 critical | `api_key = "sk-abc123"` |
| Unsafe eval/exec | 🔴 critical | `eval(user_input)` |
| Infinite loops | 🔴 critical | append-while-iterating |
| Mutable defaults | 🟠 high | `def fn(items=[])` |
| Shadowed builtins | 🟠 high | `list = [1,2,3]` |
| Bare except/pass | 🔴 critical | `except: pass` |
| Deep nesting | 🟡 medium | 5+ nested loops |
| Unused imports | ⚪ low | AST-based detection |

## Scoring

```
90-100: 🟢 PRODUCTION-READY
70-89:  🟡 NEEDS REVIEW  
50-69:  🟠 HIGH RISK
0-49:   🔴 DO NOT DEPLOY
```
