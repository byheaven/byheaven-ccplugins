# Plan: Make Skills Independent + CONTRIBUTING.md Mandatory

## Context

Two issues with the newproject plugin skills:

1. **6 skills depend on project-scaffold Step 9** for the CLAUDE.md base template. Each has: `"If it doesn't exist: create the section first (see project-scaffold Step 9 for the base template)"` — this violates skill independence. If a user runs `ci-pipeline` standalone, the instruction to "see project-scaffold Step 9" is meaningless.

2. **project-scaffold Step 6 marks CONTRIBUTING.md as optional**, but the overall convention pattern relies on it (CLAUDE.md points to CONTRIBUTING.md, release-workflow appends to it, code-quality references it). It should be mandatory.

## Changes

### 1. Inline CLAUDE.md creation in all 6 dependent skills

Replace the cross-reference `(see project-scaffold Step 9 for the base template)` with self-contained instructions. Each skill's "Update CLAUDE.md" step should handle all 3 cases independently:

**New text for the "If it doesn't exist" bullet (same in all 6 skills):**

```markdown
- **If it doesn't exist**: create a minimal one:

  ```markdown
  # CLAUDE.md

  This file provides guidance to Claude Code when working in this repository.

  ## Contributor Conventions

  Follow [CONTRIBUTING.md](CONTRIBUTING.md) for all contribution conventions.
  ```

- **If it exists** but has no `## Contributor Conventions` section, append:

  ```markdown
  ## Contributor Conventions

  Follow [CONTRIBUTING.md](CONTRIBUTING.md) for all contribution conventions.
  ```

- **If `## Contributor Conventions` already exists**, just add the following line (if not already present):

```

Then the skill-specific pointer line follows (unchanged).

### 2. Make CONTRIBUTING.md mandatory in project-scaffold

**File:** `plugins/newproject/skills/project-scaffold/SKILL.md`

- Step 6 heading: `## Step 6: CONTRIBUTING.md (optional)` → `## Step 6: CONTRIBUTING.md`
- Remove the AskUserQuestion gate (`"Would you like a minimal CONTRIBUTING.md added to the project? (yes/no)"`)
- Change to: always create from template if not present; if it exists, skip
- Update the summary table: `Optional, on user request` → `Always (if missing)`

## Files to Modify

| File | Change |
|------|--------|
| `plugins/newproject/skills/ci-pipeline/SKILL.md` | Inline CLAUDE.md creation (Step 6) |
| `plugins/newproject/skills/code-quality/SKILL.md` | Inline CLAUDE.md creation (Step 7) |
| `plugins/newproject/skills/release-workflow/SKILL.md` | Inline CLAUDE.md creation (Step 9) |
| `plugins/newproject/skills/github-repo-setup/SKILL.md` | Inline CLAUDE.md creation (Step 7) |
| `plugins/newproject/skills/dependency-management/SKILL.md` | Inline CLAUDE.md creation (Step 7) |
| `plugins/newproject/skills/security-scanning/SKILL.md` | Inline CLAUDE.md creation (Step 6) |
| `plugins/newproject/skills/project-scaffold/SKILL.md` | Step 6: remove "(optional)", remove AskUserQuestion, always create; update summary table |

### Not changed

- `plugins/newproject/skills/project-scaffold/SKILL.md` **Step 9** — already self-contained (it IS the base template). No change needed.
- `code-quality` husky reference to `release-workflow` — this is a defensive check ("if husky already exists"), not a dependency. It handles both with/without gracefully. Acceptable.
- `github-repo-setup` implicit reference to CI workflow — this is a sequencing note ("add status checks after CI runs"), not a dependency. Acceptable.

## Verification

1. `grep -rn "see project-scaffold" plugins/` — should return 0 matches
2. `grep -rn "(optional)" plugins/newproject/skills/project-scaffold/SKILL.md` — should return 0 matches
3. `npm run lint:md` — all files pass markdownlint
