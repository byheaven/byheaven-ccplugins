# ByHeaven Claude Code Plugins

> A curated collection of Claude Code plugins by ByHeaven

[English README](README.md)

这是一个精选的 Claude Code 插件市场，包含由 ByHeaven 开发和维护的实用插件。

## 📦 Available Plugins

### 🔴 xhs-publisher

**小红书自动发布插件**

自动填充小红书图文内容，通过浏览器自动化工具实现智能发布。

**功能特性**:
- ✅ 自动识别内容长度选择发布形式
- ✅ 支持文字配图 (< 140字) 和图文笔记 (≥ 140字)
- ✅ 支持从 Obsidian 笔记读取内容
- ✅ 智能生成标签
- ✅ 安全发布策略（用户最终确认）

**安装**: 参见下方安装方法

**仓库**: https://github.com/byheaven/xhs-publisher

---

## 🚀 如何安装插件

### 方法 1: 通过 Plugin Marketplace（推荐）

```bash
# 1. 添加 ByHeaven Plugin Marketplace
claude plugin marketplace add https://github.com/byheaven/byheaven-ccplugins

# 2. 安装插件
claude plugin install xhs-publisher

# 插件会自动安装到 ~/.claude/plugins/ 目录
```

### 方法 2: 直接从 GitHub 安装

```bash
# 安装单个插件（从 GitHub 仓库）
claude plugin install byheaven/xhs-publisher
```

### 方法 3: Git Clone

```bash
# 克隆插件仓库到 Claude 插件目录
cd ~/.claude/plugins/
git clone https://github.com/byheaven/xhs-publisher.git

# 重启 Claude Code 或使用 claude plugin list 查看
```

### 方法 4: 手动下载

1. 访问 https://github.com/byheaven/xhs-publisher/releases
2. 下载最新版本的压缩包
3. 解压到 `~/.claude/plugins/xhs-publisher/`
4. 重启 Claude Code

## 📋 插件列表

| 插件名称 | 描述 | 版本 | 分类 |
|---------|------|------|------|
| https://github.com/byheaven/xhs-publisher | 小红书自动发布 | 0.1.0 | automation |

## 🛠️ 开发计划

### 即将推出

- 🔜 **notion-sync**: Notion 与 Obsidian 双向同步
- 🔜 **wechat-publisher**: 微信公众号发布工具
- 🔜 **multi-platform-publisher**: 多平台一键发布

### 想法池

- 💡 **ai-image-generator**: AI 图片生成工具
- 💡 **content-optimizer**: 内容 SEO 优化建议
- 💡 **social-analytics**: 社交媒体数据分析

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

### 提交新插件

如果你想将自己的插件添加到此 Market：

1. Fork 此仓库
2. 在 `.claude-plugin/marketplace.json` 中添加你的插件信息
3. 更新 `README.md`
4. 提交 Pull Request

### 插件信息格式

```json
{
  "name": "plugin-name",
  "displayName": "插件显示名称",
  "description": "插件描述",
  "repository": "https://github.com/username/plugin-name",
  "author": {
    "name": "作者名称"
  },
  "version": "1.0.0",
  "keywords": ["keyword1", "keyword2"],
  "category": "category-name"
}
```

## 📝 插件开发指南

想要开发自己的 Claude Code 插件？参考以下资源：

- https://docs.claude.ai/plugins
- https://github.com/byheaven/xhs-publisher - 作为参考示例
- https://github.com/anthropics/claude-code-plugin-sdk

### 插件结构

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json          # 插件清单
├── commands/                 # 用户命令
├── skills/                   # 自主技能
├── agents/                   # 子代理
├── hooks/                    # 事件钩子
└── README.md                # 使用文档
```

## 📄 许可证

MIT License - 详见各插件仓库的 LICENSE 文件

## 🔗 相关链接

- **ByHeaven GitHub**: https://github.com/byheaven
- **Claude Code 官网**: https://claude.ai/code
- **问题反馈**: https://github.com/byheaven/byheaven-ccplugins/issues

## 💬 社区

如果你在使用过程中遇到问题或有建议，欢迎：

- 📧 提交 Issue
- 💬 参与 Discussions
- ⭐ Star 本项目支持我们

---

**免责声明**: 插件仅用于个人学习和提升效率。使用自动化工具时，请遵守相关平台的服务条款。

**Made with ❤️ by ByHeaven**
