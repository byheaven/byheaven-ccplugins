# ByHeaven Claude Code Plugins

> A curated collection of Claude Code plugins by ByHeaven

English | [中文 README](README.zh-CN.md)

This repository is an English-first Claude Code plugin marketplace maintained by ByHeaven.

## 📦 Available plugins

### 🔴 xhs-publisher

**Xiaohongshu (RED) auto publisher**

Auto-fills Xiaohongshu post content and publishes via browser automation.

**Key features**:
- ✅ Automatically chooses the publishing format based on content length
- ✅ Supports text+images (< 140 chars) and photo-note (≥ 140 chars)
- ✅ Can read content from Obsidian notes
- ✅ Smart tag generation
- ✅ Safe publishing flow (final confirmation by the user)

**Install**: see the installation section below

**Repository**: https://github.com/byheaven/xhs-publisher

---

## 🚀 Installation

### Option 1: via Plugin Marketplace (recommended)

```bash
# 1. Add the ByHeaven plugin marketplace
claude plugin marketplace add https://github.com/byheaven/byheaven-ccplugins

# 2. Install a plugin
claude plugin install xhs-publisher

# Plugins are installed into ~/.claude/plugins/
```

### Option 2: install directly from GitHub

```bash
# Install a single plugin from a GitHub repo
claude plugin install byheaven/xhs-publisher
```

### Option 3: git clone

```bash
# Clone the plugin repo into Claude's plugin directory
cd ~/.claude/plugins/
git clone https://github.com/byheaven/xhs-publisher.git

# Restart Claude Code (or run: claude plugin list)
```

### Option 4: manual download

1. Go to https://github.com/byheaven/xhs-publisher/releases
2. Download the latest release archive
3. Extract to `~/.claude/plugins/xhs-publisher/`
4. Restart Claude Code

## 📋 Plugin list

| Plugin | Description | Version | Category |
|---|---|---|---|
| https://github.com/byheaven/xhs-publisher | Xiaohongshu (RED) auto publishing | 0.1.0 | automation |

## 🛠️ Roadmap

### Coming soon

- 🔜 **notion-sync**: Two-way sync between Notion and Obsidian
- 🔜 **wechat-publisher**: WeChat Official Accounts publishing tool
- 🔜 **multi-platform-publisher**: One-click publishing to multiple platforms

### Idea pool

- 💡 **ai-image-generator**: AI image generation tool
- 💡 **content-optimizer**: Content SEO optimization suggestions
- 💡 **social-analytics**: Social media analytics

## 🤝 Contributing

Issues and pull requests are welcome.

### Add a new plugin

To add your plugin to this marketplace:

1. Fork this repo
2. Add your plugin entry to `.claude-plugin/marketplace.json`
3. Update `README.md` (and optionally `README.zh-CN.md`)
4. Open a pull request

### Plugin entry format

```json
{
  "name": "plugin-name",
  "displayName": "Plugin Display Name",
  "description": "Plugin description",
  "repository": "https://github.com/username/plugin-name",
  "author": {
    "name": "Author name"
  },
  "version": "1.0.0",
  "keywords": ["keyword1", "keyword2"],
  "category": "category-name"
}
```

## 📝 Plugin development guide

Resources:

- https://docs.claude.ai/plugins
- https://github.com/byheaven/xhs-publisher (reference implementation)
- https://github.com/anthropics/claude-code-plugin-sdk

### Plugin structure

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # plugin manifest
├── commands/                 # user commands
├── skills/                   # autonomous skills
├── agents/                   # sub-agents
├── hooks/                    # event hooks
└── README.md                # documentation
```

## 📄 License

MIT License — see each plugin repo for its LICENSE file.

## 🔗 Links

- **ByHeaven GitHub**: https://github.com/byheaven
- **Claude Code**: https://claude.ai/code
- **Issues**: https://github.com/byheaven/byheaven-ccplugins/issues

## 💬 Community

If you run into issues or have ideas:

- 📧 Open an issue
- 💬 Join discussions
- ⭐ Star this repo

---

**Disclaimer**: These plugins are for personal learning and productivity. When using automation tooling, please follow the target platform's Terms of Service.

**Made with ❤️ by ByHeaven**
