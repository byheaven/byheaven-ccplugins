# xhs-publisher

> 小红书自动发布 Claude Code 插件

自动填充小红书图文内容，通过 `claude-in-chrome` 浏览器自动化工具实现，支持从 Obsidian 笔记或直接文本发布。

## 功能特性

- ✅ 自动识别内容长度，选择合适的发布形式
  - **文字配图** (< 140字): 文字生成图片模式
  - **图文笔记** (≥ 140字): 富文本编辑器模式
- ✅ 支持从 Obsidian 笔记读取内容
- ✅ 智能生成相关标签（2-3个）
- ✅ 自动填充标题、正文、标签
- ✅ 安全发布：填充完成后由用户最终确认

## 前置条件

### 1. Claude in Chrome 扩展

本插件依赖 Claude in Chrome 浏览器扩展进行自动化操作。

**安装方法**:
1. 访问 https://claude.ai/chrome
2. 安装 Claude in Chrome 扩展
3. 重启 Chrome 浏览器
4. 确保扩展已启用

### 2. 小红书账号

- 需要已注册的小红书账号
- 使用前需在浏览器中登录 https://creator.xiaohongshu.com

## 安装

### 方法 1：通过 byheaven-skills marketplace 安装（推荐）

在 Claude Code 中运行：

```text
/plugin marketplace add byheaven/byheaven-skills
/plugin install xhs-publisher@byheaven-skills
```

### 方法 2：从 byheaven-skills monorepo 本地安装

```bash
git clone https://github.com/byheaven/byheaven-skills.git
cd byheaven-skills

mkdir -p ~/.claude/plugins
rsync -a skills/xhs-publisher/ ~/.claude/plugins/xhs-publisher/
```

## 使用方法

### 基本用法

```bash
# 从 Obsidian 笔记发布
/xhs-publisher:xhs note="pages/publish/cn/我的文章.md"

# 直接提供内容
/xhs-publisher:xhs content="今天发现了一家超棒的咖啡店，环境很好，咖啡也很香..."

# 提供标题和内容
/xhs-publisher:xhs title="咖啡店探店" content="今天发现了一家超棒的咖啡店..."
```

### 参数说明

| 参数 | 必填 | 说明 | 示例 |
|-----|------|------|------|
| `note` | 否 | Obsidian 笔记路径 | `"pages/publish/cn/文章.md"` |
| `title` | 否 | 标题（如提供 note 则使用文件名） | `"我的标题"` |
| `content` | 否 | 正文内容 | `"正文内容..."` |
| `tags` | 否 | 自定义标签（逗号分隔） | `"标签1,标签2,标签3"` |

**注意**: `note` 和 `content` 至少提供一个。

### 发布流程

1. **运行命令**
   ```bash
   /xhs-publisher:xhs note="pages/publish/cn/我的文章.md"
   ```

2. **自动处理**
   - 读取笔记内容
   - 计算字数，选择发布形式
   - 生成标签（如未提供）
   - 打开浏览器并导航到发布页面

3. **检查登录状态**
   - 如果未登录，会提示手动登录
   - 登录后重新运行命令

4. **自动填充内容**
   - 填充标题
   - 填充正文
   - 添加标签
   - 等待自动保存

5. **用户确认**
   - 插件完成内容填充后停止
   - 在浏览器中预览内容
   - 确认无误后手动点击"发布"按钮

## 发布形式说明

### 文字配图 (< 140字)

**适用场景**:
- 短小精悍的分享
- 日常生活记录
- 快速笔记

**特点**:
- 文字转换为图片
- 第一张图片 = 标题
- 第二张图片开始 = 正文
- 支持多种模板风格

**示例**:
```bash
/xhs-publisher:xhs content="今天天气真好，心情也跟着好起来了！推荐大家去公园走走。"
```

### 图文笔记 (≥ 140字)

**适用场景**:
- 详细的教程和指南
- 深度分享和评测
- 长篇经验总结

**特点**:
- 富文本编辑器
- 支持格式化（标题、列表等）
- 自动生成封面图
- 需要填写完整正文内容（虽然字段名为"正文摘录"）

**示例**:
```bash
/xhs-publisher:xhs note="pages/publish/cn/小红书运营指南.md"
```

## 高级用法

### 自定义标签

```bash
/xhs-publisher:xhs note="pages/publish/cn/我的文章.md" tags="效率提升,自动化,生产力工具"
```

### 从 Obsidian 笔记读取

插件会自动处理 Obsidian 笔记的 frontmatter：

```markdown
---
source: [[原始笔记]]
tags: [小红书, 发布]
date: 2024-01-22
---

这里是正文内容，frontmatter 会被自动去除。

正文支持 Markdown 格式，但发布时会转换为纯文本。
```

**规则**:
- **标题**: 使用文件名（去除 `.md` 扩展名）
- **正文**: frontmatter 之后的所有内容
- **frontmatter**: 自动检测和去除

### 内容为空时自动生成标题

如果只提供 `content` 而不提供 `title`：

```bash
/xhs-publisher:xhs content="今天学会了一个新技能..."
```

Claude 会根据内容自动生成标题，并请求确认：

```
💡 根据内容生成标题: "今日新技能分享"

是否使用此标题？
[是] [否，让我提供标题]
```

## 限制和注意事项

### 字数限制

| 字段 | 最小值 | 最大值 |
|-----|-------|-------|
| 标题 | 1字 | 20字 |
| 正文 | 1字 | 10000字 |
| 标签 | 0个 | 建议3个 |

### 使用频率

- ⚠️ 小红书可能有反自动化检测
- 建议发布间隔至少 **1小时**
- 避免短时间内频繁发布
- 每次发布由用户最终确认

### 浏览器要求

- ✅ Chrome 浏览器
- ✅ Claude in Chrome 扩展已安装
- ✅ 浏览器保持打开状态
- ✅ 已登录小红书创作者平台

## 故障排除

### 问题 1: "Browser extension is not connected"

**原因**: Claude in Chrome 扩展未运行

**解决方案**:
1. 确认已安装扩展: https://claude.ai/chrome
2. 重启 Chrome 浏览器
3. 点击扩展图标确认已启用
4. 重新运行命令

### 问题 2: "检测到未登录"

**原因**: 未登录小红书创作者平台

**解决方案**:
1. 在浏览器中访问 https://creator.xiaohongshu.com
2. 完成登录流程
3. 保持登录状态
4. 重新运行命令

### 问题 3: 内容填充失败

**可能原因**:
- 页面加载未完成
- 网络连接问题
- 页面结构已更新

**解决方案**:
1. 等待片刻后重试
2. 检查网络连接
3. 清除浏览器缓存
4. 如果问题持续，请提交 issue

### 问题 4: 标签未正确添加

**原因**: 标签格式不正确

**确保**:
- 标签以 `#` 开头
- 多个标签用空格分隔
- 标签前换两行与正文分隔

**正确格式**:
```
正文内容...

#标签1 #标签2 #标签3
```

## 最佳实践

### 1. 内容准备

- ✅ 标题简洁明了（≤ 20字）
- ✅ 正文分段清晰
- ✅ 使用换行增强可读性
- ✅ 避免特殊字符和表情（会自动过滤）

### 2. 标签选择

- ✅ 选择相关度高的标签
- ✅ 参考平台热门标签
- ✅ 2-3个标签最佳
- ❌ 避免过于宽泛的标签（如 #生活）
- ❌ 避免无关标签

### 3. 发布时机

- 🌅 早8点: 早间浏览高峰
- 🌆 午12点: 午休时间
- 🌃 晚8点: 晚间活跃时段

### 4. 内容审核

- ✅ 发布前预览内容
- ✅ 检查标题和正文格式
- ✅ 确认标签相关性
- ✅ 验证图片生成效果（文字配图）

## 技术架构

```
xhs-publisher/
├── .claude-plugin/
│   └── plugin.json          # 插件清单
├── commands/
│   └── publish.md           # 发布命令
├── skills/
│   └── xiaohongshu-publishing/
│       └── SKILL.md         # 小红书平台知识库
└── README.md                # 本文档
```

### 核心技术

- **浏览器自动化**: Claude in Chrome MCP 集成
- **内容处理**: Obsidian 笔记解析
- **智能标签**: Claude AI 生成
- **双模式支持**: 自动识别并切换发布形式

## 安全性

### 隐私保护

- ✅ 本地处理所有内容
- ✅ 不上传或存储用户数据
- ✅ 不收集任何统计信息
- ✅ 登录凭证保留在浏览器中

### 反自动化对策

- ✅ 由用户最终确认发布
- ✅ 建议发布间隔（≥ 1小时）
- ✅ 随机延迟（避免机器人特征）
- ✅ 遵守平台规则和限制

## 开发

### 插件结构

参考 [Claude Code Plugin Development Guide](https://docs.claude.ai/plugins)

### 修改技能

编辑 `skills/xiaohongshu-publishing/SKILL.md` 更新平台知识：
- DOM 选择器
- 操作流程
- 错误处理

### 测试

```bash
# 加载插件
cc --plugin-dir ~/.claude/plugins/xhs-publisher

# 运行测试
/xhs-publisher:xhs content="测试内容"
```

## 更新日志

### v0.1.0 (2024-01-22)

**首次发布**:
- ✅ 支持文字配图和图文笔记两种发布形式
- ✅ 自动识别内容长度选择发布形式
- ✅ 支持从 Obsidian 笔记读取内容
- ✅ 智能生成标签
- ✅ 浏览器自动化填充
- ✅ 安全发布策略（用户最终确认）

## 贡献

欢迎提交 Issue 和 Pull Request！

### 报告问题

如果遇到问题，请提供：
1. 错误描述
2. 使用的命令
3. 浏览器截图
4. Claude Code 版本

### 功能建议

欢迎建议新功能：
- 支持更多平台
- 批量发布
- 定时发布
- 图片上传

## 许可证

MIT License

## 作者

yubai

## 致谢

- Claude Code 团队
- claude-in-chrome 工具
- 小红书平台

---

**免责声明**: 本插件仅用于个人学习和提升效率，请遵守小红书平台服务条款。频繁或滥用自动化工具可能导致账号受限。
