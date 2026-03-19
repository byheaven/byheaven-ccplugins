# Byheaven Skills

> A collection of Agent skills — works with Claude Code, OpenAI Codex, and other AI tools

English | [中文 README](README.zh-CN.md)

## Skills

- **xhs-publisher** — Xiaohongshu (RedNote) auto publisher (browser automation)
- **newproject** — Self-contained full project setup: scaffolding, CI, linting, release automation, GitHub repo config, dependency management, and security scanning

## Installation

### Claude Code — plugin (recommended)

Installing as a plugin gives you auto-updates and a packaged `newproject`
experience in Claude Code:

```text
/plugin marketplace add byheaven/byheaven-skills
/plugin install newproject
```

### Other AI tools — npx skills

```bash
npx skills add byheaven/byheaven-skills
```

For Codex and other skill-based tools, `newproject` is self-contained. It carries
its own templates, workflows, and scripts, so using `newproject` does not require
installing helper setup skills separately.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on adding skills, commit conventions, and PR process.

## License

MIT License
