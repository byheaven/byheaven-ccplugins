---
name: project-scaffold
description: "Sets up the foundational files for a new or existing project: README, LICENSE, .gitignore, .editorconfig, and directory structure. Use this skill when the user wants to initialize a project, create a new repository, scaffold a project from scratch, add a README, choose a license, set up .gitignore, or configure consistent editor settings. Also use when the user mentions missing project files, wants to initialize git, or needs a clean project structure for a Node, Python, Go, Rust, or generic project."
---

# Project Scaffold Skill

Sets up the essential foundation files every production project needs: README, LICENSE,
.gitignore, .editorconfig, and a clean directory structure. Detects what already exists
and only creates what's missing.

## Step 0: Read the Project

Detect the project type and inventory existing files before creating anything:

```bash
# Detect project type
ls package.json pyproject.toml setup.py go.mod Cargo.toml 2>/dev/null

# Check for web framework (if package.json exists)
ls next.config.* nuxt.config.* vite.config.* angular.json svelte.config.* astro.config.* 2>/dev/null

# Check what foundational files already exist
ls README.md LICENSE .gitignore .editorconfig 2>/dev/null

# Check git status
git status 2>/dev/null || echo "git not initialized"
```

Determine:

- **Project type**: web / node / python / go / rust / other
- **What's missing**: only create files that don't already exist
- **Git status**: whether to run `git init`

Use the AskUserQuestion tool to collect required inputs before proceeding:

- If the project name is not determinable from the directory or package file: "What is the project name?"
- "Please provide a short description (1–2 sentences):"

---

## Step 1: Initialize Git (if needed)

If the project directory is not a git repository:

```bash
git init
git checkout -b main
```

If git is already initialized, skip this step entirely.

---

## Step 2: README.md

If `README.md` does not exist, create it from `assets/templates/README.md.template`.
Replace the placeholders:

- `{{PROJECT_NAME}}` → project name
- `{{DESCRIPTION}}` → short description
- `{{PROJECT_TYPE}}` → detected type for the installation section

If `README.md` already exists, check for missing standard sections (installation, usage, contributing) and add only what's missing. Do not overwrite existing content.

---

## Step 3: LICENSE

If no `LICENSE` file exists, create MIT (default):

- Copy `assets/templates/LICENSE-MIT.template`
- Replace `{{YEAR}}` with the current year
- Replace `{{AUTHOR}}` with the user's name — if unknown, use the AskUserQuestion tool: "What name should appear in the LICENSE copyright line?"

---

## Step 4: .gitignore

If no `.gitignore` exists, copy the language-specific template from `assets/gitignore/`:

- `node.gitignore` → Node.js and web projects
- `python.gitignore` → Python projects
- `go.gitignore` → Go projects
- `rust.gitignore` → Rust projects
- `generic.gitignore` → any other type

If a `.gitignore` already exists, check if it's missing common entries for the
project type and append only the missing sections. Never remove existing entries.

---

## Step 5: .editorconfig

If no `.editorconfig` exists, copy `assets/editorconfig/.editorconfig`.
This file is language-agnostic — it applies sensibly to all project types.

If `.editorconfig` already exists, skip and notify the user.

---

## Step 6: CONTRIBUTING.md

If `CONTRIBUTING.md` does not exist, create it from `assets/templates/CONTRIBUTING.md.template`.
Replace `{{PROJECT_NAME}}` with the project name.

If `CONTRIBUTING.md` already exists, skip this step.

---

## Step 7: Directory Structure

Create standard directories based on project type if they don't already exist:

**Node.js / Web:**

```bash
mkdir -p src tests docs scripts
```

**Python:**

```bash
mkdir -p src/{{package_name}} tests docs scripts
touch src/{{package_name}}/__init__.py
```

**Go:**

```bash
mkdir -p cmd/{{project_name}} internal pkg docs scripts
```

**Rust:**

```bash
# Cargo handles src/ automatically; only add extras
mkdir -p docs scripts
```

**Generic:**

```bash
mkdir -p src tests docs scripts
```

Only create directories that don't already exist.

---

## Step 8: Initial Commit

After all files are created:

```bash
git add .
git commit -m "chore: initialize project scaffold"
```

If the project already has commits, skip this step and let the user commit manually.

---

## Reference Files

- `references/decisions.md` — Why these specific files and defaults were chosen
- `assets/templates/` — File templates with `{{PLACEHOLDER}}` syntax
- `assets/gitignore/` — Language-specific .gitignore templates
- `assets/editorconfig/` — Universal .editorconfig

---

## Quick Reference: What Gets Created

| File | Created when |
|------|-------------|
| `README.md` | Always (if missing) |
| `LICENSE` | Always (if missing), default MIT |
| `.gitignore` | Always (if missing) |
| `.editorconfig` | Always (if missing) |
| `CONTRIBUTING.md` | Always (if missing) |
| `src/`, `tests/`, `docs/`, `scripts/` | If missing for detected project type |

---

## Step 9: Update CLAUDE.md

Ensure `CLAUDE.md` has a `## Contributor Conventions` section so Claude knows
where project conventions live in future sessions.

**If `CLAUDE.md` doesn't exist**, create a minimal one:

```markdown
# CLAUDE.md

This file provides guidance to Claude Code when working in this repository.

## Contributor Conventions

Follow [CONTRIBUTING.md](CONTRIBUTING.md) for all contribution conventions.
```

**If `CLAUDE.md` exists** but has no `## Contributor Conventions` section, append:

```markdown
## Contributor Conventions

Follow [CONTRIBUTING.md](CONTRIBUTING.md) for all contribution conventions.
```

**If `## Contributor Conventions` already exists**, the base pointer is present — skip.
