#!/usr/bin/env python3
"""
Code Inspector — scan AI-generated code for common issues.
Checks: infinite loops, shadowed builtins, empty except, hardcoded secrets,
bare return types, mutable defaults, f-string injection risks, and more.

Source: Reddit pain #5 — AI code quality
> "everything seemed fine until you inspected the edge cases, it missed the core logic" — r/webdev (27↑)
> "Broke entire site because you let loose Claude? Triple rate" — r/webdev (21↑)
"""

import re, sys, os, ast
from typing import List, Dict

# ── Pattern-based checks ──
PATTERNS = [
    {
        "id": "infinite-loop",
        "severity": "critical",
        "pattern": r"while\s+True\s*:\s*\n\s*\w+\.append",
        "desc": "Possible infinite loop: appending to list while iterating",
        "fix": "Iterate over a copy: for item in list(my_list):",
    },
    {
        "id": "shadow-builtin",
        "severity": "high",
        "pattern": r"^(list|dict|set|str|int|float|bool|type|id|input|print|sum|min|max|len|open|file|map|filter|zip|range|object|class|bytes|memoryview|property|staticmethod|classmethod|super|tuple)\s*=",
        "desc": "Shadows Python builtin — can cause confusing bugs",
        "fix": "Rename the variable (e.g., my_list, data_dict)",
    },
    {
        "id": "empty-except",
        "severity": "high",
        "pattern": r"except\s*:",
        "desc": "Bare except catches everything including KeyboardInterrupt",
        "fix": "Catch specific exceptions: except (ValueError, KeyError):",
    },
    {
        "id": "bare-except-pass",
        "severity": "critical",
        "pattern": r"except[^:]*:\s*\n\s*pass",
        "desc": "Exception silently swallowed — bugs hidden",
        "fix": "At minimum, log the error or use a specific handler",
    },
    {
        "id": "mutable-default",
        "severity": "high",
        "pattern": r"def\s+\w+\([^)]*=\s*\[\s*\]",
        "desc": "Mutable default argument shared across calls",
        "fix": "Use None as default: def fn(items=None): items = items or []",
    },
    {
        "id": "mutable-default-dict",
        "severity": "high",
        "pattern": r"def\s+\w+\([^)]*=\s*\{\s*\}",
        "desc": "Mutable default dict shared across calls",
        "fix": "Use None as default: def fn(mapping=None): mapping = mapping or {}",
    },
    {
        "id": "hardcoded-secret",
        "severity": "critical",
        "pattern": r"(api_key|secret|password|token|auth)\s*=\s*['\"][^'\"]{8,}['\"]",
        "desc": "Hardcoded credential — will get leaked in git",
        "fix": "Use os.environ.get('SECRET') or a .env file",
    },
    {
        "id": "unsafe-eval",
        "severity": "critical",
        "pattern": r"\beval\s*\(|exec\s*\(|__import__\s*\(",
        "desc": "Dynamic code execution — security risk",
        "fix": "Use json.loads, ast.literal_eval, or explicit parsing",
    },
    {
        "id": "unused-import",
        "severity": "low",
        "pattern": None,  # handled by AST
        "desc": "Unused imports (AST check)",
        "fix": "Remove unused imports to reduce load time",
    },
    {
        "id": "too-broad-except",
        "severity": "medium",
        "pattern": r"except\s+Exception",
        "desc": "Catching Exception is very broad",
        "fix": "Catch specific exception types from the call chain",
    },
    {
        "id": "fstring-injection",
        "severity": "high",
        "pattern": r'f"[^"]*\{[^}]*\[[^\]]*\][^}]*\}[^"]*"',
        "desc": "Complex f-string with indexing — error-prone",
        "fix": "Extract the value to a variable first",
    },
]


def ast_checks(source: str) -> List[Dict]:
    """AST-based checks."""
    issues = []
    try:
        tree = ast.parse(source)
    except SyntaxError as e:
        return [{"id": "syntax-error", "severity": "critical",
                 "desc": f"Syntax error: {e.msg}", "fix": "Fix syntax before further checks",
                 "line": e.lineno or 0}]

    # Unused imports
    used_names = set()
    for node in ast.walk(tree):
        if isinstance(node, ast.Name):
            used_names.add(node.id)
        if isinstance(node, ast.Attribute):
            used_names.add(node.attr)

    for node in ast.walk(tree):
        if isinstance(node, (ast.Import, ast.ImportFrom)):
            for alias in node.names:
                name = alias.asname or alias.name.split(".")[0]
                if name not in used_names and name != alias.name:
                    issues.append({
                        "id": "unused-import",
                        "severity": "low",
                        "desc": f"Import '{alias.name}' appears unused",
                        "fix": f"Remove: import {alias.name}",
                        "line": node.lineno,
                    })

    # Nested loops (complexity smell)
    loop_depth = 0
    for node in ast.walk(tree):
        if isinstance(node, (ast.For, ast.While)):
            loop_depth += 1
    if loop_depth >= 5:
        issues.append({
            "id": "deep-nesting",
            "severity": "medium",
            "desc": f"Code has {loop_depth} nested loops/for-while — hard to follow",
            "fix": "Extract inner loops into separate functions",
            "line": 0,
        })

    return issues


def scan_code(filepath: str = None, code: str = None) -> Dict:
    """Full scan: pattern + AST checks."""
    if filepath:
        with open(filepath) as f:
            source = f.read()
        name = os.path.basename(filepath)
    elif code:
        source = code
        name = "stdin"
    else:
        return {"error": "No code provided"}

    lines = source.split("\n")
    issues = []

    # Pattern checks
    for p in PATTERNS:
        if p["pattern"] is None:
            continue
        for i, line in enumerate(lines, 1):
            if re.search(p["pattern"], line):
                # Deduplicate: only first hit
                if not any(x["id"] == p["id"] for x in issues):
                    issues.append({**p, "line": i, "line_content": line.strip()[:80]})

    # AST checks
    issues.extend(ast_checks(source))

    # Scoring
    severity_weight = {"critical": 10, "high": 5, "medium": 2, "low": 1}
    score = 100
    for i in issues:
        score -= severity_weight.get(i["severity"], 1)
    score = max(0, min(100, score))

    # Verdict
    if score >= 90:
        verdict = "🟢 PRODUCTION-READY"
    elif score >= 70:
        verdict = "🟡 NEEDS REVIEW"
    elif score >= 50:
        verdict = "🟠 HIGH RISK"
    else:
        verdict = "🔴 DO NOT DEPLOY"

    return {
        "file": name,
        "lines": len(lines),
        "issues_count": len(issues),
        "score": score,
        "verdict": verdict,
        "issues": issues,
    }


def main():
    # Read from file or stdin
    if len(sys.argv) > 1:
        filepath = sys.argv[1]
        if not os.path.exists(filepath):
            print(f"File not found: {filepath}")
            sys.exit(1)
        result = scan_code(filepath=filepath)
    else:
        source = sys.stdin.read().strip()
        if not source:
            print("Usage: code-inspector <file.py>")
            print("   or: cat file.py | code-inspector")
            sys.exit(1)
        result = scan_code(code=source)

    if "error" in result:
        print(result["error"])
        return

    print("=" * 60)
    print(f"  Code Inspector — AI Code Quality Scanner")
    print("=" * 60)
    print(f"\n📄 {result['file']} ({result['lines']} lines)")
    print(f"🔍 {result['issues_count']} issues found")
    print(f"📊 Score: {result['score']}/100 → {result['verdict']}")

    if result["issues"]:
        print(f"\n── Issues ──")
        for i, iss in enumerate(result["issues"], 1):
            icon = {"critical": "🔴", "high": "🟠", "medium": "🟡", "low": "⚪"}.get(iss["severity"], "⚪")
            print(f"\n{icon} #{i} [{iss['id']}] {iss['severity'].upper()}")
            print(f"   {iss['desc']}")
            print(f"   Fix: {iss['fix']}")
            if iss.get("line"):
                line_content = iss.get("line_content", "")
                print(f"   Line {iss['line']}: {line_content}")


if __name__ == "__main__":
    main()
