# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

xhs-publisher is a Claude Code plugin for automating content publishing to Xiaohongshu (小红书/Little Red Book) Creator Platform. It uses browser automation via `claude-in-chrome` MCP tools.

## Architecture

```
.claude-plugin/plugin.json  - Plugin manifest
commands/publish.md         - Main /xhs-publisher:xhs command
skills/xhs-publisher/SKILL.md - Platform knowledge (DOM selectors, workflows)
```

**Key design decisions:**
- Markdown-based, no build step required
- Commands define workflows with YAML frontmatter
- Skills contain platform-specific knowledge that may need updates if XHS changes their UI
- Safety-first: never auto-clicks "发布" (publish) button

## Testing

```bash
# Load plugin and test manually
cc --plugin-dir ~/.claude/plugins/xhs-publisher
/xhs-publisher:xhs content="测试内容"
```

No automated tests - requires browser interaction and XHS account.

## Publishing Modes

Content length determines the publishing mode:

| Mode | Chars | URL Parameter | Entry Button |
|------|-------|---------------|--------------|
| 文字配图 (Text with Image) | < 140 | `target=image` | "文字配图" |
| 图文笔记 (Article) | >= 140 | `target=article` | "新的创作" |

## Critical Implementation Details

### Tag Format
Tags must be separated from content by two newlines:
```
正文内容...

#标签1 #标签2 #标签3
```

### Content Fields
Both modes require filling the **complete content** (not a summary) in the final publish page:
- 文字配图: Fill "正文文本框" with full content + tags
- 图文笔记: Fill "正文摘录" textarea with full content + tags (despite the name suggesting "excerpt")

### Character Limits
- Title: max 20 characters
- Content: max 10,000 characters

## Modifying Platform Knowledge

When XHS updates their UI, edit `skills/xhs-publisher/SKILL.md`:
- DOM selectors and `find` patterns
- Step sequences for each publishing mode
- Error messages and recovery steps
