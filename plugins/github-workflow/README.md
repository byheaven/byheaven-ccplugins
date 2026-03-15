# github-workflow

A Claude Code plugin that sets up a complete, production-ready GitHub release pipeline for any project.

## What It Does

Installs a `github-release-workflow` skill that guides Claude through setting up:

```
Conventional commits (commitlint + husky)
    │
    ▼
Push to main → release-please maintains a Release PR
    │             (auto-updates CHANGELOG.md + bumps version)
    ▼
Developer edits CHANGELOG.md with AI assistance
    │  → Linear-style prose, user-centric, not commit-centric
    ▼
Merge Release PR → release-please creates tag
    │
    ▼
publish.yml triggers → creates GitHub Release + runs publish step
```

## Installation

```bash
npx skills add byheaven/byheaven-skills
```

Or install just this plugin:

```bash
npx skills add byheaven/byheaven-skills --skill github-release-workflow
```

## Usage

Once installed, ask Claude to set up your release workflow:

```
Set up the GitHub release workflow for this project
```

Claude will:
1. Detect your project type (Node.js, Python, Go, Rust, or other)
2. Configure commitlint for conventional commits enforcement
3. Set up release-please with the correct release type
4. Add a tag-triggered publish workflow (customized for your stack)
5. Provide an AI changelog guide for Linear-style release notes
6. Walk you through a dry run to verify everything works

## Supported Project Types

| Type | Version file | Notes |
|------|-------------|-------|
| Node.js | `package.json` | Also sets up commitlint + husky locally |
| Python | `pyproject.toml` | Publishes to PyPI |
| Go | tag only | Uploads binary to GitHub Release |
| Rust | `Cargo.toml` | Can publish to crates.io |
| Other | `version.txt` | Configurable publish step |

## What's Included

- **GitHub Actions workflows**: `release-please.yml`, `publish.yml`, `commitlint-check.yml`
- **Config files**: `release-please-config.json`, `commitlint.config.js`
- **Script**: `extract-release-notes.sh` — parses `CHANGELOG.md` for the current version
- **AI changelog guide**: system prompt for rewriting raw commits into Linear-style prose
- **Human workflow doc**: step-by-step guide for editing Release PR changelogs

## License

MIT
