# ByHeaven Skills

> ByHeaven 的 Claude Code skills/plugins 单仓库（monorepo）

[English README](README.md)

## Skills

- **xhs-publisher**（`skills/xhs-publisher`）— 小红书自动发布（浏览器自动化）

## 安装方式



### 1) 快速安装（skills CLI）

```bash
npx skills add byheaven/byheaven-skills
```

或者：克隆本仓库并将某个 skill 复制到你的 Claude 插件目录：

```bash
git clone https://github.com/byheaven/byheaven-skills.git
cd byheaven-skills

mkdir -p ~/.claude/plugins
rsync -a skills/xhs-publisher/ ~/.claude/plugins/xhs-publisher/
```

### 2) 添加为 Claude Code 的 Plugin Marketplace

在 Claude Code 中运行：

```text
/plugin marketplace add byheaven/byheaven-skills
```

### 3) 安装某个 skill/plugin

添加 marketplace 后：

- 通过界面：打开 `/plugin`，在 marketplace 中选择并安装
- 直接安装：

```text
/plugin install xhs-publisher@byheaven-skills
```

- 或者直接对 agent 说：
  - “Please install Skills from github.com/byheaven/byheaven-skills”

### 4) 更新

```text
/plugin marketplace update byheaven-skills
```

## 仓库结构

每个 skill 位于 `skills/<name>/`，并尽量保持为可独立使用的 Claude Code 插件结构（包含 `.claude-plugin/plugin.json`、`commands/`、`skills/` 等）。

## 许可证

MIT License
