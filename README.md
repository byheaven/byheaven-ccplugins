# ByHeaven Skills

> A monorepo of Claude Code skills/plugins by ByHeaven

English | [中文 README](README.zh-CN.md)

## Plugins

- **xhs-publisher** (`plugins/xhs-publisher`) — Xiaohongshu (RED) auto publisher (browser automation)

## Installation

This repo supports multiple installation workflows (similar to `JimLiu/baoyu-skills`).

### 1) Quick Install (skills CLI)

```bash
npx skills add byheaven/byheaven-skills
```

Or install by cloning this repo and copying a specific skill into your Claude plugins directory:

```bash
git clone https://github.com/byheaven/byheaven-skills.git
cd byheaven-skills

mkdir -p ~/.claude/plugins
rsync -a plugins/xhs-publisher/ ~/.claude/plugins/xhs-publisher/
```

### 2) Add as Claude Code Plugin Marketplace

In Claude Code, run:

```text
/plugin marketplace add byheaven/byheaven-skills
```

### 3) Install a skill/plugin

After adding the marketplace:

- Browse UI: open `/plugin` and install from the marketplace
- Direct install:

```text
/plugin install xhs-publisher@byheaven-skills
```

- Or ask the agent:
  - “Please install Skills from github.com/byheaven/byheaven-skills”

### 4) Update

```text
/plugin marketplace update byheaven-skills
```

## Repo structure

Each plugin lives under `plugins/<name>/` and is intended to be self-contained (it includes its own `.claude-plugin/plugin.json`, `commands/`, `skills/`, etc.).

## License

MIT License
