# Byheaven Skills

> Byheaven 的 Claude Code skills/plugins 单仓库（monorepo）

[English README](README.md)

## Plugins

- **xhs-publisher**（`plugins/xhs-publisher`）— 小红书自动发布（浏览器自动化）
- **newproject**（`plugins/newproject`）— 完整项目初始化：脚手架、CI、代码规范、发布自动化、GitHub 仓库配置、依赖管理与安全扫描

## 安装方式

### 1) npx skills（适用于绝大部分 AI 工具）

```bash
npx skills add byheaven/byheaven-skills
```

### 2) Claude Code 插件

在 Claude Code 中运行：

```text
/plugin marketplace add byheaven/byheaven-skills
```

然后安装指定插件：

```text
/plugin install xhs-publisher
/plugin install newproject
```

## 许可证

MIT License
