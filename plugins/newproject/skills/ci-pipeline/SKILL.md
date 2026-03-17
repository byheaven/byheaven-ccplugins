---
name: ci-pipeline
description: "Sets up GitHub Actions CI pipelines for any project type. Use this skill when the user wants to add continuous integration, set up automated tests, configure GitHub Actions workflows, add a build pipeline, test on multiple language versions, or cache dependencies in CI. Also use when the user mentions CI failing, wanting to test on a matrix of versions, speed up CI runs, cancel stale workflows, or set up a test and lint pipeline for Node, Python, Go, Rust, or any other project."
---

# CI Pipeline Skill

Sets up a production-ready GitHub Actions CI pipeline for any project type.
Each workflow template includes: test execution, linting, build verification,
dependency caching, matrix strategies, and concurrency groups to cancel stale runs.

## Step 0: Read the Project

Before doing anything, detect the project type and existing CI configuration:

```bash
# Detect project type
ls package.json pyproject.toml setup.py go.mod Cargo.toml 2>/dev/null

# Check for web framework
ls next.config.* nuxt.config.* vite.config.* angular.json svelte.config.* 2>/dev/null

# Check existing CI
ls .github/workflows/ 2>/dev/null

# Get package manager (Node projects)
ls package-lock.json yarn.lock pnpm-lock.yaml bun.lockb 2>/dev/null
```

Determine:
- **Project type**: web / node / python / go / rust / other
- **Package manager** (Node): npm / yarn / pnpm / bun (check for lockfile)
- **Test command**: from package.json scripts / pyproject.toml / Makefile — if unclear, use the AskUserQuestion tool: "What command runs your tests? (e.g. npm test, pytest, go test ./...)"
- **Existing CI**: avoid overwriting workflows with the same purpose

---

## Step 1: Copy the Workflow Template

Copy the language-specific workflow from `assets/workflows/` to `.github/workflows/`:

| Project type | Template file | Destination |
|-------------|--------------|-------------|
| Node.js | `ci-node.yml` | `.github/workflows/ci.yml` |
| Web app | `ci-node.yml` | `.github/workflows/ci.yml` |
| Python | `ci-python.yml` | `.github/workflows/ci.yml` |
| Go | `ci-go.yml` | `.github/workflows/ci.yml` |
| Rust | `ci-rust.yml` | `.github/workflows/ci.yml` |
| Other | `ci-generic.yml` | `.github/workflows/ci.yml` |

---

## Step 2: Customize the Workflow

After copying, customize based on the detected project:

### Node.js / Web
- Set the **Node.js version matrix** (default: `[18, 20, 22]`; for web apps a single LTS version is fine)
- Set the **package manager** in the install step (npm / yarn / pnpm / bun)
- Verify the **test command** matches `package.json` scripts (`npm test` / `npm run test` / `vitest` / `jest`)
- For web apps: adjust or remove the matrix (typically only need the LTS version)

### Python
- Set the **Python version matrix** (default: `["3.11", "3.12", "3.13"]`)
- Set the **install command**: `pip install -e ".[dev]"` / `pip install -r requirements-dev.txt`
- Set the **test command**: `pytest` / `python -m pytest`
- Set the **lint command**: `ruff check .` / `flake8 .` / skip if no linter

### Go
- Set the **Go version** (default: latest stable; check `go.mod` for minimum)
- Verify the **test command** (`go test ./...` works for most projects)
- The build step uses `go build ./...` — adjust the binary target if needed

### Rust
- Verify the **toolchain**: `stable` is the default; change to `nightly` if required
- The test step uses `cargo test` — adjust for workspace crates if needed

---

## Step 3: Create the .github/workflows Directory (if needed)

```bash
mkdir -p .github/workflows
```

---

## Step 4: Commit

```bash
git add .github/workflows/ci.yml
git commit -m "ci: add GitHub Actions CI pipeline"
```

Then push and check the Actions tab to confirm the workflow appears and runs correctly.

---

## Step 5: Verify

After pushing, walk the user through verifying:

1. Go to the GitHub repo → **Actions** tab
2. The CI workflow should appear and start running
3. Check that all steps pass (install → lint → test → build)
4. If any step fails, read the error log and fix the issue

---

## Reference Files

- `references/decisions.md` — Why concurrency groups, caching strategies, and matrix defaults were chosen
- `assets/workflows/` — All language-specific CI workflow templates

---

## Key Features in All Templates

| Feature | What it does |
|---------|-------------|
| Concurrency groups | Cancels the previous run on the same branch when a new push arrives — saves CI minutes |
| Dependency caching | Caches node_modules / pip / Go modules / Cargo registry — makes reruns fast |
| Matrix strategies | Tests against multiple language versions to catch compatibility issues |
| Lint before test | Fails fast on code style issues before running slower tests |
| Build verification | Confirms the project actually compiles / bundles after tests pass |
