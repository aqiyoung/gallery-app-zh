#!/bin/bash
# 一键同步上游并更新汉化的脚本
# 使用方法：./scripts/sync-and-translate.sh

set -e

UPSTREAM_BRANCH="main"

echo "🚀 开始同步上游并更新汉化..."
echo ""

# 1. 检查工作区是否干净
if ! git diff-index --quiet HEAD --; then
    echo "❌ 工作区有未提交的更改，请先提交或暂存"
    git status --short
    exit 1
fi

# 2. 获取上游最新代码
echo "📥 获取上游最新代码..."
git fetch upstream --quiet || {
    echo "➕ 添加上游远程仓库..."
    git remote add upstream https://github.com/google-ai-edge/gallery-app.git
    git fetch upstream --quiet
}

# 3. 备份当前汉化文件
echo "💾 备份当前汉化文件..."
cp app/src/main/res/values-zh-rCN/strings.xml /tmp/strings-zh-backup.xml

# 4. 合并上游更新
echo "🔀 合并上游更新..."
if ! git merge upstream/$UPSTREAM_BRANCH --no-edit; then
    echo ""
    echo "❌ 合并出现冲突！"
    echo ""
    echo "解决步骤："
    echo "   1. 查看冲突文件: git status"
    echo "   2. 解决冲突后: git add ."
    echo "   3. 继续合并: git merge --continue"
    echo ""
    echo "💡 汉化文件备份在: /tmp/strings-zh-backup.xml"
    exit 1
fi

# 5. 检查是否有新的字符串需要翻译
echo ""
echo "🔍 检查翻译差异..."

EN_COUNT=$(grep -c '<string name=' app/src/main/res/values/strings.xml 2>/dev/null || echo "0")
ZH_COUNT=$(grep -c '<string name=' app/src/main/res/values-zh-rCN/strings.xml 2>/dev/null || echo "0")

if [ "$EN_COUNT" -gt "$ZH_COUNT" ]; then
    NEW_STRINGS=$((EN_COUNT - ZH_COUNT))
    echo ""
    echo "⚠️  发现 $NEW_STRINGS 条新字符串需要翻译！"
    echo ""
    echo "请更新汉化文件: app/src/main/res/values-zh-rCN/strings.xml"
    echo ""
    read -p "是否现在编辑汉化文件？(y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ${EDITOR:-vim} app/src/main/res/values-zh-rCN/strings.xml
    fi
else
    echo "✅ 没有新的字符串需要翻译"
fi

# 6. 提交更新
echo ""
echo "📝 提交更新..."
SYNC_DATE=$(date +"%Y-%m-%d")
git add -A
git commit -m "sync: 同步上游更新 ($SYNC_DATE)" || echo "没有新的更改需要提交"

echo ""
echo "✅ 同步完成！"
echo ""
echo "后续步骤："
echo "   1. 检查汉化是否完整"
echo "   2. 本地测试编译: ./gradlew assembleDebug"
echo "   3. 推送到 GitHub: git push origin master"
echo "   4. 打新版本 tag: git tag v1.x.x && git push origin v1.x.x"
