# 娇娇 - Android应用

娇娇的大学生活 Android应用，基于Cordova构建。

## 应用信息

- **应用名称**: 娇娇
- **包名**: com.jiaojiao.app
- **版本**: 1.0.0
- **目标网址**: https://xyj.lifont.cn

## 构建步骤

### 环境要求

1. 安装Node.js (推荐v18+)
2. 安装Java JDK 11或17
3. 安装Android SDK
4. 配置ANDROID_HOME环境变量

### 安装依赖

```bash
npm install -g cordova
npm install
```

### 添加Android平台

```bash
cordova platform add android@12.0.0
```

### 构建Debug版本

```bash
cordova build android
```

APK输出路径: `platforms/android/app/build/outputs/apk/debug/app-debug.apk`

### 构建Release版本

```bash
cordova build android --release
```

APK输出路径: `platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk`

### 签名Release版本

1. 生成密钥库（只需执行一次）:
```bash
keytool -genkey -v -keystore jiaojiao.keystore -alias jiaojiao -keyalg RSA -keysize 2048 -validity 10000
```

2. 签名APK:
```bash
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore jiaojiao.keystore platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk jiaojiao
```

3. 优化APK:
```bash
zipalign -v 4 platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk jiaojiao-v1.0.0.apk
```

## 应用功能

- 加载网页 https://xyj.lifont.cn
- 支持返回键导航
- 支持文件下载
- 支持地理位置
- 适配Android 5.0+ (API 21+)

## 图标和启动画面

图标和启动画面已预生成在 `res/` 目录下：
- 应用图标: `res/icon/android/`
- 启动画面: `res/screen/android/`

## 注意事项

1. 首次构建需要下载Gradle和Android依赖，请耐心等待
2. 确保Android SDK包含API 34
3. 如果遇到构建错误，尝试清理后重新构建:
   ```bash
   cordova clean
   cordova build android
   ```
