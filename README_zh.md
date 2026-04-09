# Google AI Edge Gallery 汉化版

基于 [Google AI Edge Gallery](https://github.com/google-ai-edge/gallery-app) 的中文本地化版本。

## 功能特性

- ✅ 完整中文界面（314 条翻译）
- ✅ 支持端侧 LLM 模型推理
- ✅ 图片理解、音频转文字
- ✅ 基准测试功能
- ✅ 智能体技能系统

## 下载

前往 [Releases](../../releases) 页面下载最新汉化版 APK。

## 编译说明

### 环境要求

- JDK 17+
- Android SDK (compileSdk 35)
- Gradle 8.x

### 本地编译

```bash
# 克隆仓库
git clone https://github.com/YOUR_USERNAME/gallery-app-zh.git
cd gallery-app-zh/Android/src

# 编译 Debug APK
./gradlew assembleDebug

# 编译 Release APK (需要签名配置)
./gradlew assembleRelease
```

### GitHub Actions 自动构建

1. Fork 本仓库
2. 前往 Actions 页面
3. 选择 "Build and Release APK" 工作流
4. 点击 "Run workflow" 输入版本号
5. 等待构建完成后在 Releases 下载

## 翻译贡献

翻译文件位于：
```
app/src/main/res/values-zh-rCN/strings.xml
```

如发现翻译问题，欢迎提交 Issue 或 PR。

## 原版信息

- 官方仓库：https://github.com/google-ai-edge/gallery-app
- 许可证：Apache License 2.0

## 致谢

感谢 Google AI Edge 团队开源此优秀项目。
