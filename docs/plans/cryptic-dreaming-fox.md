# Plan: Consolidate Project Conventions + Update Plugin Flow

## Context

After the full project setup, conventions are scattered across 4+ locations:

- **CLAUDE.md** has a 7-step release workflow that doesn't belong there (it's not Claude-specific)
- **CONTRIBUTING.md** is thin (44 lines) and missing key workflows like release
- **docs/ai-changelog-guide.md** is well-written but the name implies "AI-only" — humans need it too
- Plugin `references/ai-changelog-guide.md` is a duplicate (but is a plugin asset for target projects — should stay)

Goal: one authoritative place for ALL conventions, accessible to both humans and AI, no plugin dependency. **AND** update the newproject plugin so future projects follow the same pattern.

## Approach

Three principles:

1. **CONTRIBUTING.md** = single entry point for all contributor-facing conventions
2. **docs/** = detailed reference guides (too long for CONTRIBUTING.md)
3. **CLAUDE.md** = Claude-specific rules + short pointers to shared docs

## Part A: This Repo

### A1. Rename `docs/ai-changelog-guide.md` → `docs/changelog-style-guide.md`

- `git mv docs/ai-changelog-guide.md docs/changelog-style-guide.md`
- Update heading: "AI Changelog Writing Guide" → "Changelog Style Guide"
- Update intro blockquote to remove AI-only framing:
  > Use this guide when editing auto-generated changelog sections into Linear-style prose. Works as both a human reference and an AI system prompt.
- Body content unchanged (290 lines)

### A2. Expand `CONTRIBUTING.md`

Add two sections before "Reporting Issues":

**Release Workflow** (~30 lines):

- How release-please works (auto-creates Release PRs from conventional commits)
- How to edit the changelog: brief editing steps
- Link to `docs/changelog-style-guide.md` for the full style reference
- What happens after merge (tag → GitHub Release)
- Quick command reference for CLI/AI users (find PR, checkout, edit, push, merge)

**Changelog Style** (~10 lines):

- Short paragraph explaining Linear-style prose changelogs
- Key principles (4 bullets: user-centric, bold headlines, never modify version header, omit internal changes)
- Link to full guide

### A3. Slim down `CLAUDE.md`

- **Remove** the "Release Workflow" section (7-step procedure, lines 59-69)
- **Add** a short pointer section:

```markdown
## Contributor Conventions

Follow CONTRIBUTING.md for commit conventions, PR guidelines, and the release workflow.
Use docs/changelog-style-guide.md when rewriting changelog sections.

When the user says "release", "ship", or "merge the release PR":
follow the Release Workflow section in CONTRIBUTING.md.
```

---

## Part B: Update the newproject Plugin

These changes ensure that when the plugin runs on OTHER projects, it sets up the same CONTRIBUTING.md-centric convention pattern.

### B1. Update `release-workflow` SKILL.md

**Step 5** — rename the target file:

- Before: `Copy references/ai-changelog-guide.md to docs/ai-changelog-guide.md`
- After: `Copy references/ai-changelog-guide.md to docs/changelog-style-guide.md`
- Update the description to call it "Changelog Style Guide", not "AI Changelog Guide"

**Add new Step 5.5** — update the target project's CONTRIBUTING.md:

After copying the style guide, append a "Release Workflow" section and a "Changelog Style" section to the target project's CONTRIBUTING.md (if it exists). Content mirrors what we wrote for this repo in A2:

- How release-please works
- Editing steps + link to `docs/changelog-style-guide.md`
- Post-merge flow
- Quick CLI reference
- Changelog style summary with 4 key principles

If CONTRIBUTING.md doesn't exist, create a minimal one with the release-related sections (Getting Started + Commit Convention + Release Workflow + Changelog Style + Reporting Issues). This ensures the release-workflow skill is self-sufficient — it doesn't depend on project-scaffold having run first.

**Step 8** — update references:

- Change `docs/ai-changelog-guide.md` → `docs/changelog-style-guide.md` in the explanation
- Change "Use the AI changelog guide" → "Use the changelog style guide"

### B2. Update `release-workflow` references/changelog-editing-workflow.md

- Line 64: Change `docs/ai-changelog-guide.md` → `docs/changelog-style-guide.md` in the prompt template

### B3. Update `project-scaffold` CONTRIBUTING.md template

The template at `assets/templates/CONTRIBUTING.md.template` stays minimal (as it is now). The release-workflow skill will append release-specific sections when it runs after project-scaffold. No change needed to the template itself — the modular approach (each skill appends its own section) is better than trying to pre-populate everything.

---

## Files to Modify

### This repo (Part A)

| File | Action |
|------|--------|
| `docs/ai-changelog-guide.md` | Rename → `docs/changelog-style-guide.md`, update heading/intro |
| `CONTRIBUTING.md` | Expand with Release Workflow + Changelog Style sections |
| `CLAUDE.md` | Remove release steps, add pointers to CONTRIBUTING.md |

### Plugin skills (Part B)

| File | Action |
|------|--------|
| `plugins/newproject/skills/release-workflow/SKILL.md` | Update Step 5 (rename target), add Step 5.5 (update CONTRIBUTING.md), update Step 8 references |
| `plugins/newproject/skills/release-workflow/references/changelog-editing-workflow.md` | Update `docs/ai-changelog-guide.md` → `docs/changelog-style-guide.md` in prompt template |

### No changes needed

- `plugins/newproject/skills/release-workflow/references/ai-changelog-guide.md` — plugin asset, keeps original filename
- `plugins/newproject/skills/project-scaffold/assets/templates/CONTRIBUTING.md.template` — stays minimal; release-workflow creates or appends independently
- `README.md` — already points to CONTRIBUTING.md

## Commit

`docs: consolidate conventions into CONTRIBUTING.md and update plugin flow`

## Verification

1. `grep -r "ai-changelog-guide" . --include="*.md" | grep -v "plugins/newproject/skills/release-workflow/references/"` — should only match the plugin's references/ directory (the asset copy that stays as-is)
2. Read CONTRIBUTING.md end-to-end — should be self-contained for any new contributor
3. Read CLAUDE.md — should contain no operational workflows, only Claude-specific rules + pointers
4. Read the release-workflow SKILL.md — Step 5 should target `docs/changelog-style-guide.md`, new Step 5.5 should update CONTRIBUTING.md
5. `npm run lint:md` — all modified files pass markdownlint
