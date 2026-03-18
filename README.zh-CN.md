# Byheaven Skills

> Byheaven 出品的 Agent skills 集合——支持 Claude Code、OpenAI Codex 等 AI 工具

[English README](README.md)

## Skills

- **xhs-publisher** — 小红书自动发布（浏览器自动化）
- **newproject** — 完整项目初始化：脚手架、CI、代码规范、发布自动化、GitHub 仓库配置、依赖管理与安全扫描

## 安装方式

### Claude Code——插件方式（推荐）

以插件方式安装可获得自动更新、一次性编排多个 skills 的斜杠命令（如 `/newproject`），以及 skills 的批量开关：

```text
/plugin marketplace add byheaven/byheaven-skills
/plugin install newproject
```

### 其他 AI 工具——npx skills

```bash
npx skills add byheaven/byheaven-skills
```

## 许可证

MIT License
