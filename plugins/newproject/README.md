# newproject

`newproject` is a self-contained project setup skill packaged as a Claude Code
plugin. It can scaffold a repository from scratch or upgrade an existing project
to a production-ready baseline with CI, code quality, release automation, GitHub
repository setup, dependency management, and security scanning.

## What It Does

The canonical entrypoint is the standalone `newproject` skill.
It vendors its own templates, workflows, and scripts, so it works even when no
other `newproject` helper skills are installed.

```text
Tier 1 — Foundation
  scaffold and repo baseline
  release workflow
  CI pipeline

Tier 2 — Quality and Governance
  code quality
  GitHub repository setup
  dependency management

Tier 3 — Security
  security scanning
```

The plugin still bundles the older focused setup skills for compatibility and
advanced direct use, but they are no longer required for normal `newproject`
usage.

## Installation

### Claude Code plugin

```text
/plugin marketplace add byheaven/byheaven-skills
/plugin install newproject
```

### Codex and other skill-based tools

```bash
npx skills add byheaven/byheaven-skills
```

Use `newproject` directly. It is self-contained and does not rely on sibling
setup skills being installed.

## Usage

### Full project setup

Ask naturally:

```text
Set up my new project
/newproject
```

The skill detects the project type, inventories what already exists, presents a
checklist, and applies the selected setup sections in dependency order.

### Advanced compatibility skills

The bundled helper skills remain available for users who want to apply one setup
area in isolation:

- `project-scaffold`
- `code-quality`
- `release-workflow`
- `ci-pipeline`
- `github-repo-setup`
- `dependency-management`
- `security-scanning`

These are compatibility surfaces. The supported end-to-end workflow is `newproject`.

## Supported Project Types

- **Web** (Next.js, Nuxt, Astro, Remix, SvelteKit, and similar)
- **Node.js** (libraries, APIs, CLIs)
- **Python** (applications, libraries, data tooling)
- **Go** (services, CLIs, libraries)
- **Rust** (systems, CLIs, libraries)
- **Generic** (any other language)

## License

MIT
