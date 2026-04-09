# 汉化更新指南

本文档说明如何同步官方源码更新并保持汉化。

## 📋 更新方式

### 方式一：自动同步（推荐）

GitHub Actions 会每天自动检查上游更新：
- 发现新提交时自动合并到 master
- 发送通知提醒检查翻译

手动触发：
```
仓库 → Actions → Sync Upstream and Rebase → Run workflow
```

### 方式二：手动同步

```bash
# 1. 检查是否有更新
./scripts/check-upstream.sh

# 2. 一键同步并更新
./scripts/sync-and-translate.sh

# 或手动操作：
git fetch upstream
git merge upstream/main
# 更新汉化文件...
git push origin master
```

## 🔄 完整更新流程

### 1. 检查更新

```bash
./scripts/check-upstream.sh
```

输出示例：
```
🔔 发现 5 个新提交：
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
abc123 Add new feature (upstream/main)
def456 Fix bug
...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

⚠️  发现 strings.xml 有更新，可能需要更新汉化！
```

### 2. 合并更新

```bash
# 自动合并并提示翻译
./scripts/sync-and-translate.sh
```

或手动：

```bash
git fetch upstream
git merge upstream/main
```

### 3. 更新汉化

打开 `app/src/main/res/values-zh-rCN/strings.xml`，对照 `values/strings.xml` 添加新翻译。

翻译规则：
- 技术术语保持原文：LLM、API、SDK 等
- 格式占位符不变：`%s`、`%d`、`%1$s`
- 界面文字翻译：按钮、提示、错误信息

### 4. 测试编译

```bash
./gradlew assembleDebug
```

### 5. 发布新版本

```bash
# 提交更改
git add .
git commit -m "sync: 更新汉化至最新版本"

# 推送到 GitHub
git push origin master

# 打新版本 tag（自动触发构建）
git tag v1.0.2
git push origin v1.0.2
```

## 🛠️ 常见问题

### Q: 合并冲突怎么办？

如果 `strings.xml` 冲突：

```bash
# 1. 查看冲突
git status

# 2. 手动合并（保留两边更改）
# 在冲突文件中，保留 <<<<<<< 和 >>>>>>> 之间的正确内容

# 3. 标记已解决
git add app/src/main/res/values-zh-rCN/strings.xml

# 4. 继续合并
git merge --continue
```

### Q: 如何批量翻译新字符串？

```bash
# 提取新增的英文字符串
diff -u <(grep '<string name=' app/src/main/res/values/strings.xml) \
        <(grep '<string name=' app/src/main/res/values-zh-rCN/strings.xml) | \
        grep "^+" | grep '<string name='
```

### Q: 翻译进度统计

```bash
# 统计条目数
echo "英文: $(grep -c '<string name=' app/src/main/res/values/strings.xml)"
echo "中文: $(grep -c '<string name=' app/src/main/res/values-zh-rCN/strings.xml)"
```

## 📚 相关链接

- 官方仓库：https://github.com/google-ai-edge/gallery-app
- 我们的仓库：https://github.com/aqiyoung/gallery-app-zh
- GitHub Actions：https://github.com/aqiyoung/gallery-app-zh/actions

## 🎯 版本管理建议

建议使用语义化版本：
- `v1.0.0` - 初始汉化版本
- `v1.0.1` - 修复翻译错误
- `v1.1.0` - 同步上游新功能
- `v2.0.0` - 大版本更新
