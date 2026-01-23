---
name: xhs
description: 自动发布内容到小红书创作者平台
---

# 小红书自动发布命令

本命令用于自动填充小红书图文内容，支持从 Obsidian 笔记或直接文本发布。

## 使用方法

```bash
# 从 Obsidian 笔记发布
/xhs-publisher:xhs note="pages/publish/cn/我的文章.md"

# 直接提供内容
/xhs-publisher:xhs content="今天发现了一家超棒的咖啡店..."

# 提供标题和内容
/xhs-publisher:xhs title="咖啡店探店" content="今天发现了一家超棒的咖啡店..."
```

## 命令参数

- `note`: Obsidian 笔记路径（相对于 vault 根目录）
- `title`: 标题（可选，如果提供 `note` 则使用文件名）
- `content`: 正文内容
- `tags`: 自定义标签（可选，逗号分隔，如："标签1,标签2,标签3"）

## 工作流程

### 1. 解析输入

**如果提供了 `note` 参数**:
1. 读取 Obsidian 笔记文件
2. 提取 frontmatter（如果存在）
3. 使用文件名（去除 `.md` 扩展名）作为标题
4. 提取正文内容（去除 frontmatter）

**如果提供了 `content` 参数**:
1. 如果没有提供 `title`，则使用 Claude 根据内容生成标题
2. 向用户确认生成的标题
3. 等待用户确认后继续

### 2. 计算内容长度并选择发布形式

- 计算正文字符数（不包括标题）
- **< 140字**: 使用文字配图入口
- **≥ 140字**: 使用图文笔记入口

### 3. 生成标签

如果没有提供自定义标签:
1. 使用 Claude 根据内容智能生成 2-3 个相关标签
2. 标签应该简洁、相关、有热度

标签规则:
- 每个标签以 `#` 开头
- 多个标签用空格分隔
- 最多 3 个标签
- 避免过于宽泛或无关的标签

### 4. 获取浏览器上下文

```javascript
tabs_context_mcp(createIfEmpty: true)
```

### 5. 导航到对应发布页面

**文字配图** (< 140字):
```javascript
navigate("https://creator.xiaohongshu.com/publish/publish?target=image")
```

**图文笔记** (≥ 140字):
```javascript
navigate("https://creator.xiaohongshu.com/publish/publish?target=article")
```

### 6. 检测登录状态

检查页面是否重定向到登录页面或显示登录提示。

如果未登录:
1. 提示用户："请先在浏览器中登录小红书创作者平台"
2. 等待用户登录
3. 提示用户登录后重新运行命令

### 7. 填充内容

#### 7.1 文字配图流程 (< 140字)

**步骤 1: 点击"文字配图"按钮**
```javascript
find("文字配图 button")
click()
wait(2)
```

**步骤 2: 创建第一张图片（标题）**
```javascript
find("真诚分享经验或资讯 textbox")
click()
type(title)
wait(1)
```

**步骤 3: 生成第一张图片**
```javascript
find("生成图片 button")
click()
wait(3)  // 等待图片生成
```

**步骤 4: 选择模板并下一步**
```javascript
// 使用默认选中的模板
find("下一步 button")
click()
wait(2)
```

**步骤 5: 创建第二张图片（正文）**
```javascript
find("再写一张")
click()
wait(1)

find("在这里输入正文 textbox")
click()
type(content)
wait(1)
```

**步骤 6: 生成第二张图片**
```javascript
find("生成图片 button")
click()
wait(3)
```

**步骤 7: 下一步进入发布页面**
```javascript
find("下一步 button")
click()
wait(2)
```

**步骤 8: 填写标题**
```javascript
find("填写标题会有更多赞哦 input")
form_input(title)
```

**步骤 9: 填充完整正文内容和标签**
```javascript
find(包含标题的 textbox)  // 正文文本框
click()
key("cmd+a")  // 全选现有内容
type(content + "\n\n" + tags)  // 填充完整正文 + 标签
```

**重要**: 正文文本框会自动填充第一张图片的内容（标题），需要替换为完整的正文内容 + 标签。

#### 7.2 图文笔记流程 (≥ 140字)

**步骤 1: 点击"新的创作"按钮**
```javascript
find("新的创作 button")
click()
wait(2)
```

**步骤 2: 填写标题**
```javascript
find("输入标题")
click()
type(title)
```

**步骤 3: 填写正文**
```javascript
click(ref_55)  // 正文编辑器 generic 元素
type(content)
wait(2)  // 等待自动保存
```

**步骤 4: 点击一键排版**
```javascript
find("一键排版 button")
click()
wait(3)  // 等待排版预览生成
```

**步骤 5: 选择模板并下一步**
```javascript
// 使用默认选中的模板
find("下一步 button")
click()
wait(2)
```

**步骤 6: 填写完整正文内容和标签**

**重要**: 虽然输入框名称是"正文摘录"，但必须填充**完整的正文内容**，不是摘要。

```javascript
find("输入正文摘录 textarea")
click()
type(content + "\n\n" + tags)  // 填充完整正文内容 + 标签
```

### 8. 停止并提示用户

完成所有内容填充后:

1. 截图显示最终页面
2. 显示成功消息:
   ```
   ✅ 内容已填充完成！

   📋 标题: {title}
   📝 内容: {content_preview}...
   🏷️ 标签: {tags}

   请在浏览器中审核内容，确认无误后点击"发布"按钮。
   ```
3. **不要自动点击"发布"按钮**

## 错误处理

### 未登录

```
❌ 检测到未登录小红书创作者平台

请按以下步骤操作：
1. 在浏览器中访问 https://creator.xiaohongshu.com
2. 完成登录
3. 重新运行此命令
```

### 内容为空

```
❌ 错误：内容不能为空

请提供 note 或 content 参数。

示例：
/xhs-publisher:xhs note="pages/publish/cn/我的文章.md"
/xhs-publisher:xhs content="文章内容..."
```

### 笔记文件不存在

```
❌ 错误：找不到笔记文件

文件路径: {note_path}

请检查文件路径是否正确。路径应该相对于 Obsidian vault 根目录。
```

### 页面元素未找到

```
⚠️ 警告：无法找到页面元素

这可能是因为：
1. 页面结构已更新
2. 页面加载未完成
3. 网络连接问题

建议：
- 等待片刻后重试
- 检查浏览器网络连接
- 如果问题持续，请报告 issue
```

### 操作超时

```
⏱️ 超时：操作未在预期时间内完成

可能原因：
- 网络速度较慢
- 服务器响应延迟
- 图片生成时间过长

建议：
- 检查网络连接
- 稍后重试
```

## 限制和注意事项

1. **字数限制**:
   - 标题: 最多 20 字
   - 正文: 最多 10000 字

2. **标签限制**:
   - 建议 2-3 个标签
   - 避免过多标签

3. **图片限制**（文字配图）:
   - 最多 18 张图片
   - 本插件默认创建 2 张（标题 + 正文）

4. **反自动化**:
   - 小红书可能有反自动化机制
   - 建议不要频繁使用（间隔至少 1 小时）
   - 每次发布前由用户最终确认

5. **浏览器要求**:
   - 需要安装 Claude in Chrome 扩展
   - Chrome 浏览器需要保持打开状态

## 最佳实践

1. **内容准备**:
   - 标题简洁明了
   - 正文分段清晰
   - 使用换行增强可读性

2. **标签选择**:
   - 选择相关度高的标签
   - 参考平台热门标签
   - 避免过于宽泛的标签

3. **发布时机**:
   - 考虑用户活跃时间
   - 避免频繁发布
   - 保持发布节奏

4. **内容审核**:
   - 始终在发布前预览
   - 检查标题和正文格式
   - 确认标签相关性

## 技术细节

### Obsidian 笔记处理

读取笔记时:
1. 使用 `Read` 工具读取文件
2. 检测并解析 YAML frontmatter
3. 提取正文内容（去除 frontmatter）
4. 使用文件名作为标题

Frontmatter 示例:
```yaml
---
source: [[原始笔记]]
tags: [小红书, 发布]
---

正文内容从这里开始...
```

### 标签生成算法

使用 Claude 分析内容生成标签:
1. 提取内容关键词
2. 匹配小红书热门标签
3. 生成 2-3 个相关标签
4. 确保标签简洁、相关

### 等待时间建议

- 页面导航: 2 秒
- 点击操作: 1 秒
- 图片生成: 3 秒
- 自动保存: 1-2 秒

根据网络状况可能需要调整。

## 使用技能

本命令会自动调用 `xiaohongshu-publishing` 技能，该技能包含：
- 小红书创作者平台详细流程
- DOM 选择器和元素定位
- 两种发布形式的完整步骤
- 错误处理和故障排除

参考: `/Users/yubai/.claude/plugins/xhs-publisher/skills/xiaohongshu-publishing/SKILL.md`

## 示例场景

### 场景 1: 从 Obsidian 笔记发布短内容

```bash
/xhs-publisher:xhs note="pages/publish/cn/今日分享.md"
```

笔记内容:
```markdown
今天发现了一家超棒的咖啡店，环境很好，咖啡也很香。推荐给大家！
```

结果: 使用文字配图模式（< 140字）

### 场景 2: 从 Obsidian 笔记发布长内容

```bash
/xhs-publisher:xhs note="pages/publish/cn/小红书运营指南.md"
```

笔记内容（> 140字）: 完整的运营指南文章

结果: 使用图文笔记模式（≥ 140字）

### 场景 3: 直接提供内容

```bash
/xhs-publisher:xhs content="分享一个提升效率的小技巧：使用自动化工具管理社交媒体内容发布，可以节省大量时间。"
```

Claude 会生成标题并请求确认。

### 场景 4: 自定义标签

```bash
/xhs-publisher:xhs note="pages/publish/cn/我的文章.md" tags="效率提升,自动化,生产力工具"
```

使用自定义标签而非自动生成。

## 更新日志

### v0.1.0 (2024-01-22)
- 初始版本
- 支持文字配图和图文笔记两种发布形式
- 支持从 Obsidian 笔记读取内容
- 自动生成标签
- 安全发布（需用户最终确认）
