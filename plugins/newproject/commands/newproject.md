---
description: "Orchestrates full project setup by detecting project type, inventorying existing configuration, and running selected skills in dependency order. Run this command to set up a new project end-to-end."
allowed-tools: Bash, Read, Write, Edit, Glob, Grep, AskUserQuestion
argument-hint: "[--tier1 | --all | skill-name]"
---

# /newproject Command

Sets up a new or existing project end-to-end by orchestrating all newproject skills
in the correct dependency order.

## Step 1: Detect Project Type

Run these detection commands to understand the project:

```bash
# Project type
ls package.json pyproject.toml setup.py go.mod Cargo.toml 2>/dev/null

# Web framework (if Node)
ls next.config.* nuxt.config.* vite.config.* angular.json svelte.config.* astro.config.* 2>/dev/null

# Package manager (if Node)
ls package-lock.json yarn.lock pnpm-lock.yaml bun.lockb 2>/dev/null

# Git status
git remote -v 2>/dev/null || echo "no remote"

# Existing GitHub configuration
ls .github/ 2>/dev/null
ls .github/workflows/ 2>/dev/null
```

Classify the project as: **web** / **node** / **python** / **go** / **rust** / **other**

## Step 2: Inventory Existing Setup

Check what is already configured:

```bash
# Foundation
ls README.md LICENSE .gitignore .editorconfig 2>/dev/null

# CI
ls .github/workflows/ci* .github/workflows/CI* 2>/dev/null

# Release workflow
ls .github/workflows/release* 2>/dev/null
ls release-please-config.json .release-please-manifest.json 2>/dev/null

# Code quality
ls .eslintrc* eslint.config.* prettier.config.* ruff.toml .golangci.yml rustfmt.toml 2>/dev/null
ls .husky/ .pre-commit-config.yaml 2>/dev/null

# GitHub config
ls .github/pull_request_template.md .github/ISSUE_TEMPLATE/ .github/CODEOWNERS 2>/dev/null

# Dependency management
ls .github/dependabot.yml 2>/dev/null

# Security
ls .github/workflows/codeql.yml .github/workflows/dependency-review.yml 2>/dev/null
```

## Step 3: Present Setup Checklist

Present the user with a checklist. Mark items that are **already done** with ✅.
For new items, default selections follow the plan's tier system:

```
Project: [detected type] — [project name]

Foundation (Tier 1 — recommended for all projects):
  [✅ or □] project-scaffold   — README, LICENSE, .gitignore, .editorconfig
  [✅ or □] release-workflow   — conventional commits + release-please + changelogs
  [✅ or □] ci-pipeline        — GitHub Actions CI with test, lint, build

Quality & Governance (Tier 2 — recommended for team projects):
  [✅ or □] code-quality       — ESLint/Prettier/Ruff + pre-commit hooks
  [✅ or □] github-repo-setup  — PR template, issue forms, CODEOWNERS, branch protection
  [✅ or □] dependency-management — Dependabot + auto-merge

Security (Tier 3 — recommended for public/production projects):
  [✅ or □] security-scanning  — CodeQL + dependency vulnerability review
```

Use the AskUserQuestion tool: "Which skills do you want to run? (Press Enter to run all unchecked Tier 1 items, or specify: 'all', 'tier1', 'tier2', 'all tiers', or specific skill names)"

If the user passes an argument:

- `--tier1` or `tier1`: run only Tier 1 skills that aren't done
- `--all` or `all`: run all skills that aren't done
- Skill name (e.g., `ci-pipeline`): run that single skill

## Step 4: Execute Skills in Dependency Order

Run the selected skills in this exact order (skip already-done items):

1. `project-scaffold` — no dependencies
2. `code-quality` — uses .editorconfig from project-scaffold
3. `release-workflow` — may share husky with code-quality
4. `ci-pipeline` — needs project type (detected in Step 1)
5. `github-repo-setup` — references CI status checks
6. `dependency-management` — needs ecosystem detection
7. `security-scanning` — adds alongside CI workflows

For each skill, invoke it by loading the corresponding SKILL.md and following its steps.

**Shared dependency: husky**
If both `code-quality` and `release-workflow` are in the run list, note that both
may use husky. The `code-quality` skill checks for existing husky installation before
running `husky init`. Run `code-quality` before `release-workflow` in the sequence.

## Step 5: Summary

After all selected skills complete, present a summary:

```
✅ Setup complete for [project name] ([type] project)

Configured:
  ✅ project-scaffold    — README.md, LICENSE (MIT), .gitignore, .editorconfig
  ✅ release-workflow    — commitlint + release-please + publish.yml
  ✅ ci-pipeline         — .github/workflows/ci.yml (Node [version] matrix)
  ✅ code-quality        — ESLint + Prettier + lint-staged + husky pre-commit
  ✅ github-repo-setup   — PR template + issue forms + branch protection
  ✅ dependency-management — Dependabot weekly updates + auto-merge
  ✅ security-scanning   — CodeQL + dependency-review

Manual steps remaining:
  □ GitHub Settings → Actions → Workflow permissions: Read and write
  □ GitHub Settings → Actions → Allow PRs: enabled (for release-please)
  □ GitHub Settings → General → Allow auto-merge (for Dependabot)
  □ GitHub Settings → Security & analysis → Enable Secret scanning
  □ After first CI run: add status check names to branch protection
```

List only the manual steps relevant to the skills that were actually run.
