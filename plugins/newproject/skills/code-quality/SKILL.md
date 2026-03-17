---
name: code-quality
description: "Sets up linters, formatters, and pre-commit hooks for consistent code quality. Use this skill when the user wants to add ESLint, Prettier, Ruff, gofmt, golangci-lint, rustfmt, clippy, lint-staged, husky, or pre-commit hooks. Also use when the user mentions inconsistent formatting, wanting to enforce code style automatically, setting up pre-commit checks, adding markdownlint, or integrating linting into the development workflow for Node, Python, Go, or Rust projects."
---

# Code Quality Skill

Sets up linters, formatters, and pre-commit hooks to enforce consistent code style
automatically. Each tool is configured with production-ready defaults; adjust to
taste after setup.

## Step 0: Read the Project

```bash
# Detect project type
ls package.json pyproject.toml go.mod Cargo.toml 2>/dev/null

# Check if husky is already installed (Node projects)
cat package.json | grep -q '"husky"' && echo "husky present" || echo "husky absent"

# Check for existing configs
ls .eslintrc* eslint.config.* .prettierrc* prettier.config.* ruff.toml .pre-commit-config.yaml .golangci.yml rustfmt.toml .markdownlint.json 2>/dev/null
```

Only install tools that aren't already configured. If the project already has an ESLint config, check whether it's using the flat config format (`eslint.config.*`); if not, migrate it. Preserve any project-specific rules.

---

## Step 1: Node.js / Web — ESLint + Prettier + lint-staged + husky

### Install dependencies

```bash
npm install --save-dev \
  eslint \
  @eslint/js \
  prettier \
  eslint-config-prettier \
  lint-staged \
  husky
```

For TypeScript projects, also install:

```bash
npm install --save-dev \
  typescript-eslint \
  @typescript-eslint/eslint-plugin \
  @typescript-eslint/parser
```

### Create config files

Create `eslint.config.js` from `assets/config/eslint.config.js`.
Create `prettier.config.js` from `assets/config/prettier.config.js`.

### Set up lint-staged in package.json

Add to `package.json`:

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,css,md,yml,yaml}": ["prettier --write"]
  }
}
```

### Set up husky pre-commit hook

**Check if husky is already installed first** (from `release-workflow` setup):

```bash
# Only run husky init if not already done
ls .husky/ 2>/dev/null || npx husky init
```

Add the pre-commit hook:

```bash
echo "npx lint-staged" > .husky/pre-commit
chmod +x .husky/pre-commit
```

If `.husky/pre-commit` already exists (from another skill), append:

```bash
echo "npx lint-staged" >> .husky/pre-commit
```

---

## Step 2: Python — Ruff

### Install

```bash
pip install ruff
# Or add to pyproject.toml dev dependencies
```

### Create ruff.toml

Copy `assets/config/ruff.toml` to the project root.

### Set up pre-commit (Python projects)

Install the pre-commit framework:

```bash
pip install pre-commit
```

Copy `assets/hooks/pre-commit` to `.pre-commit-config.yaml`.

Install the hooks:

```bash
pre-commit install
```

---

## Step 3: Go — golangci-lint

### Install golangci-lint

```bash
# macOS
brew install golangci-lint

# Linux / CI
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin
```

### Configure

Create `.golangci.yml` in the project root:

```yaml
# .golangci.yml
run:
  timeout: 5m

linters:
  enable:
    - gofmt
    - goimports
    - govet
    - errcheck
    - staticcheck
    - unused
    - gosimple

issues:
  exclude-rules:
    - path: _test\.go
      linters: [errcheck]
```

### Add to CI

The `ci-go.yml` template already includes `go vet ./...`. Add golangci-lint:

```yaml
- name: Lint (golangci-lint)
  uses: golangci/golangci-lint-action@v6
  with:
    version: latest
```

---

## Step 4: Rust — rustfmt + clippy

Both are included with `rustup`. Ensure they are installed:

```bash
rustup component add rustfmt clippy
```

Create `rustfmt.toml` in the project root:

```toml
edition = "2021"
max_width = 100
tab_spaces = 4
```

The `ci-rust.yml` template already runs `cargo fmt --check` and `cargo clippy`.
No additional setup needed — Rust's tooling is self-contained.

---

## Step 5: All Projects — markdownlint

### Install

```bash
# Node projects (globally or devDep)
npm install --save-dev markdownlint-cli2

# Non-Node projects: install globally
npm install --global markdownlint-cli2
```

Copy `assets/config/.markdownlint.json` to the project root.

Add to lint-staged (Node projects):

```json
{
  "lint-staged": {
    "*.md": ["markdownlint-cli2 --fix"]
  }
}
```

---

## Step 6: Verify

```bash
# Node: run lint manually
npx eslint . --ext .js,.jsx,.ts,.tsx
npx prettier --check .

# Python: run ruff
ruff check .
ruff format --check .

# Pre-commit: test all hooks
pre-commit run --all-files  # Python
git add . && npx lint-staged  # Node (dry run via staged files)
```

---

## Reference Files

- `references/decisions.md` — Why Ruff over flake8+black, why flat ESLint config, etc.
- `assets/config/` — All config files with sensible defaults
- `assets/hooks/pre-commit` — Python pre-commit-config.yaml template

---

## Step 7: Update CLAUDE.md

Add a linting pointer to `CLAUDE.md` so Claude knows what lint tooling is set up.

Check if `CLAUDE.md` has a `## Contributor Conventions` section:

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

For **Node/Web** projects:
> `Linting: enforced by pre-commit hooks (lint-staged). Run \`npm run lint\` manually. markdownlint covers \`*.md\` files.`

For **Python** projects:
> `Linting: enforced by pre-commit hooks (ruff). Run \`ruff check .\` and \`ruff format --check .\` manually.`

For **Go** projects:
> `Linting: enforced by golangci-lint. Run \`golangci-lint run\` manually.`

For **Rust** projects:
> `Linting: enforced by clippy and rustfmt. Run \`cargo clippy\` and \`cargo fmt --check\` manually.`
