#!/bin/bash

echo "=========================================="
echo "娇娇 Android应用构建脚本"
echo "=========================================="
echo ""

# 检查Node.js
echo "[1/5] 检查Node.js..."
if ! command -v node &> /dev/null; then
    echo "错误: 未找到Node.js，请先安装Node.js"
    exit 1
fi
echo "Node.js版本: $(node -v)"

# 检查Cordova
echo ""
echo "[2/5] 检查Cordova..."
if ! command -v cordova &> /dev/null; then
    echo "正在安装Cordova..."
    npm install -g cordova
fi
echo "Cordova版本: $(cordova -v)"

# 安装依赖
echo ""
echo "[3/5] 安装项目依赖..."
npm install

# 添加Android平台
echo ""
echo "[4/5] 配置Android平台..."
if [ ! -d "platforms/android" ]; then
    echo "添加Android平台..."
    cordova platform add android@12.0.0
else
    echo "Android平台已存在，准备构建..."
fi

# 构建APK
echo ""
echo "[5/5] 构建APK..."
echo "正在构建Debug版本..."
cordova build android

if [ $? -ne 0 ]; then
    echo ""
    echo "构建失败！请检查错误信息。"
    exit 1
fi

echo ""
echo "=========================================="
echo "构建成功！"
echo "=========================================="
echo "APK路径: platforms/android/app/build/outputs/apk/debug/app-debug.apk"
echo ""

# 复制APK到输出目录
mkdir -p output
cp "platforms/android/app/build/outputs/apk/debug/app-debug.apk" "output/娇娇-v1.0.0-debug.apk"
echo "已复制到: output/娇娇-v1.0.0-debug.apk"

# 询问是否构建Release版本
echo ""
read -p "是否构建Release版本? (y/n): " buildRelease
if [ "$buildRelease" = "y" ] || [ "$buildRelease" = "Y" ]; then
    echo ""
    echo "正在构建Release版本..."
    cordova build android --release
    
    if [ -f "jiaojiao.keystore" ]; then
        echo ""
        echo "发现签名密钥，正在签名..."
        jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore jiaojiao.keystore platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk jiaojiao
        
        # 查找zipalign
        ZIPALIGN=$(find $ANDROID_HOME/build-tools -name "zipalign" | sort -V | tail -1)
        if [ -n "$ZIPALIGN" ]; then
            $ZIPALIGN -v 4 platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk output/娇娇-v1.0.0-release.apk
        else
            cp "platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk" "output/娇娇-v1.0.0-release-unsigned.apk"
        fi
    else
        echo ""
        echo "未找到签名密钥，Release版本未签名。"
        echo "如需签名，请先生成密钥库:"
        echo "keytool -genkey -v -keystore jiaojiao.keystore -alias jiaojiao -keyalg RSA -keysize 2048 -validity 10000"
        cp "platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk" "output/娇娇-v1.0.0-release-unsigned.apk"
    fi
fi

echo ""
echo "=========================================="
echo "构建完成！"
echo "=========================================="
echo "输出目录: output/"
ls -la output/
