# HermesMade Growth Plan
## Data-Driven Iteration Strategy — 2026-05-02

---

## Current Baseline: ZERO

| Platform | Asset | ⭐ | 🍴/💿 | 14d Views | 14d Clones |
|---|---|---|---|---|---|
| GitHub | HermesMade | 0 | 0 | 0 | 0 |
| GitHub | claude-intel-monitor | 0 | 0 | 0 | 0 |
| GitHub | cursor-doctor | 0 | 0 | 0 | 0 |
| GitHub | hermesmade-site-cf | 0 | 0 | 0 | 0 |
| ClawHub | (no profile exists) | — | — | — | — |

**Root cause**: All repos have zero discoverability. No ClawHub presence. READMEs are incomplete.

---

## Phase 1: Fix the Basics (This Week)

### 1.1 cursor-doctor README — Highest Priority (D → A)

Current: 40 lines, no badges, no examples, "pip install cursor-doctor" doesn't work

Actions:
- [ ] Add shields.io badges (Python, license, PyPI version)
- [ ] Add real install command: `git clone` or `pip install git+https://...`
- [ ] Add `## Examples` section with 3 real error→fix demos
- [ ] Add terminal screenshot showing diagnose output
- [ ] Add 6-category error table with counts
- [ ] Add bilingual description (Chinese + English)

### 1.2 claude-intel-monitor README (B → A)

Current: Good content but fully Chinese, no English

Actions:
- [ ] Add English introduction paragraph
- [ ] Add `## Examples` section with benchmark output
- [ ] Add screenshot of benchmark table
- [ ] Add DeepSeek 91.1% baseline mention

### 1.3 HermesMade README (B+ → A)

Current: 200 lines, good structure, missing visuals

Actions:
- [ ] Add terminal demo GIF/SVG showing pipeline output
- [ ] Add architecture diagram (Excalidraw/ASCII)
- [ ] Add English summary in first paragraph

### 1.4 hermesmade-site-cf README (F → C)

Actions:
- [ ] Create minimal README with link to live site
- [ ] Add "China-accessible mirror" badge
- [ ] Link back to main HermesMade repo

---

## Phase 2: Launch on ClawHub (Week 2)

### 2.1 Publish Priority (Seize First-Mover Advantage)

ClawHub keyword demand analysis:

| Keyword | Search Volume Proxy | Has Existing Skill? |
|---|---|---|
| cursor | 4.153 demand score | ❌ NO — first mover! |
| claude | 4.122 demand score | ❌ NOT for monitor |
| monitor | 4.199 demand score | ❌ NO |
| error | 4.012 demand score | ❌ NO |

**Priority 1: cursor-doctor → ClawHub**
- Name: `cursor-doctor` (no existing skill with this slug)
- Tags: cursor, ide, debug, ai, error, fix, vscode
- Publish via: `clawhub sync --all` after creating SKILL.md

**Priority 2: claude-intel-monitor → ClawHub**
- Name: `claude-intel-monitor`
- Tags: claude, gpt, benchmark, monitor, ai, quality, deepseek

**Priority 3: HermesMade tools individually → ClawHub**
- `api-cost-compare` — cost, api, pricing
- `code-inspector` — code, quality, security, analyze
- `model-watch` — model, quality, degradation, benchmark
- `prompt-inspector` — prompt, censorship, compliance
- `task-cost-estimator` — cost, estimate, budget

### 2.2 ClawHub Publishing Template

Each skill needs:
```
SKILL.md with:
  - Clear display name (English, memorable)
  - 2-line description (appears in search)
  - Tags matching search keywords
  - Link to GitHub repo in description
  - README with install + example
```

---

## Phase 3: Cross-Link & SEO (Week 3)

### 3.1 Cross-Linking Strategy

```
GitHub README ⇄ ClawHub skill page
  - GitHub README: "Also available on ClawHub: clawhub.ai/skills/cursor-doctor"
  - ClawHub skill: "Source & docs: github.com/minirr890112-byte/cursor-doctor"
```

### 3.2 SEO Keywords to Target

Based on successful ClawHub skills + GitHub discoverability:

| Skill | Primary Keywords | 
|---|---|
| cursor-doctor | Cursor IDE fix, Cursor crash fix, Cursor error, MCP Client Closed |
| claude-intel-monitor | Claude degradation, GPT getting dumber, AI benchmark, model quality |
| hermesmade-daily-pipeline | AI pain points, developer complaints, Reddit V2EX scan |

---

## Phase 4: Iterate with Data (Ongoing)

### 4.1 Traffic Monitoring

- [ ] Set up GitHub traffic API cron (weekly check)
- [ ] Set up ClawHub stats polling
- [ ] Track: views → clones → stars → installs pipeline

### 4.2 Version Iteration (Copy Top Performers)

self-improving-agent has **31 versions** — this signals active maintenance.
- Aim for 1 version bump per week per active skill
- Each bump = improved GitHub README or new feature

### 4.3 Content Marketing

- [ ] Write V2EX post about cursor-doctor (pain point → tool story)
- [ ] Post on r/cursor, r/ClaudeAI subreddits
- [ ] Create Twitter thread from benchmark data

---

## Success Metrics (30-Day Target)

| Metric | Current | Target |
|---|---|---|
| GitHub stars (total across 4 repos) | 0 | 20+ |
| GitHub clones | 0 | 50+ |
| ClawHub published skills | 0 | 5+ |
| ClawHub total installs | 0 | 50+ |

---

## Immediate Actions (Today)

1. ✅ Audit complete — GROWTH-PLAN.md created
2. [ ] Fix cursor-doctor README (top priority — biggest gap)
3. [ ] Create SKILL.md for cursor-doctor → ready for ClawHub publish
4. [ ] Create SKILL.md for claude-intel-monitor → ready for ClawHub publish
5. [ ] Add English section to claude-intel-monitor README
6. [ ] Push all changes to GitHub
