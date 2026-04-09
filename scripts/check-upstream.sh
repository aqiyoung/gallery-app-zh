#!/bin/bash
# 本地检查上游更新的脚本
# 使用方法：./scripts/check-upstream.sh

set -e

UPSTREAM_REPO="https://github.com/google-ai-edge/gallery-app.git"
UPSTREAM_BRANCH="main"

echo "🔍 检查上游更新..."

# 添加上游远程仓库（如果不存在）
if ! git remote | grep -q "^upstream$"; then
    echo "➕ 添加上游远程仓库..."
    git remote add upstream $UPSTREAM_REPO
fi

# 获取上游最新代码
echo "📥 获取上游最新代码..."
git fetch upstream --quiet

# 检查新提交
NEW_COMMITS=$(git log HEAD..upstream/$UPSTREAM_BRANCH --oneline 2>/dev/null | wc -l)

if [ "$NEW_COMMITS" -gt 0 ]; then
    echo ""
    echo "🔔 发现 $NEW_COMMITS 个新提交："
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    git log HEAD..upstream/$UPSTREAM_BRANCH --oneline --decorate
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    
    # 检查 strings.xml 是否有变化
    if git diff HEAD upstream/$UPSTREAM_BRANCH -- app/src/main/res/values/strings.xml | grep -q .; then
        echo "⚠️  发现 strings.xml 有更新，可能需要更新汉化！"
        echo ""
        echo "更改内容："
        git diff HEAD upstream/$UPSTREAM_BRANCH -- app/src/main/res/values/strings.xml | head -50
        echo ""
    fi
    
    echo "💡 建议操作："
    echo "   1. 合并上游更新: git merge upstream/$UPSTREAM_BRANCH"
    echo "   2. 检查并更新汉化: vim app/src/main/res/values-zh-rCN/strings.xml"
    echo "   3. 提交更新: git add . && git commit -m 'sync: 更新汉化'"
    echo "   4. 推送: git push origin master"
else
    echo "✅ 已经是最新版本，无需更新"
fi

# 显示当前版本信息
echo ""
echo "📋 当前版本信息："
echo "   本地最新提交: $(git log -1 --oneline)"
echo "   上游最新提交: $(git log upstream/$UPSTREAM_BRANCH -1 --oneline)"

# 统计翻译进度
EN_COUNT=$(grep -c '<string name=' app/src/main/res/values/strings.xml 2>/dev/null || echo "0")
ZH_COUNT=$(grep -c '<string name=' app/src/main/res/values-zh-rCN/strings.xml 2>/dev/null || echo "0")

echo ""
echo "📊 翻译进度: $ZH_COUNT / $EN_COUNT 条"
if [ "$EN_COUNT" -gt "$ZH_COUNT" ]; then
    echo "⚠️  还有 $((EN_COUNT - ZH_COUNT)) 条未翻译"
fi
