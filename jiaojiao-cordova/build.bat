@echo off
chcp 65001 >nul
echo ==========================================
echo 娇娇 Android应用构建脚本
echo ==========================================
echo.

:: 检查Node.js
echo [1/5] 检查Node.js...
node -v >nul 2>&1
if errorlevel 1 (
    echo 错误: 未找到Node.js，请先安装Node.js
    pause
    exit /b 1
)
echo Node.js版本: 
node -v

:: 检查Cordova
echo.
echo [2/5] 检查Cordova...
call cordova -v >nul 2>&1
if errorlevel 1 (
    echo 正在安装Cordova...
    call npm install -g cordova
)
echo Cordova版本: 
call cordova -v

:: 安装依赖
echo.
echo [3/5] 安装项目依赖...
call npm install

:: 添加Android平台
echo.
echo [4/5] 配置Android平台...
if not exist "platforms\android" (
    echo 添加Android平台...
    call cordova platform add android@12.0.0
) else (
    echo Android平台已存在，准备构建...
)

:: 构建APK
echo.
echo [5/5] 构建APK...
echo 正在构建Debug版本...
call cordova build android

if errorlevel 1 (
    echo.
    echo 构建失败！请检查错误信息。
    pause
    exit /b 1
)

echo.
echo ==========================================
echo 构建成功！
echo ==========================================
echo APK路径: platforms\android\app\build\outputs\apk\debug\app-debug.apk
echo.

:: 复制APK到输出目录
if not exist "output" mkdir output
copy "platforms\android\app\build\outputs\apk\debug\app-debug.apk" "output\娇娇-v1.0.0-debug.apk" >nul
echo 已复制到: output\娇娇-v1.0.0-debug.apk

:: 询问是否构建Release版本
echo.
set /p buildRelease="是否构建Release版本? (y/n): "
if /i "%buildRelease%"=="y" (
    echo.
    echo 正在构建Release版本...
    call cordova build android --release
    
    if exist "jiaojiao.keystore" (
        echo.
        echo 发现签名密钥，正在签名...
        jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore jiaojiao.keystore platforms\android\app\build\outputs\apk\release\app-release-unsigned.apk jiaojiao
        
        if exist "%ANDROID_HOME%\build-tools\*\zipalign.exe" (
            for /d %%a in ("%ANDROID_HOME%\build-tools\*") do (
                "%%a\zipalign.exe" -v 4 platforms\android\app\build\outputs\apk\release\app-release-unsigned.apk output\娇娇-v1.0.0-release.apk
                goto :signed
            )
        )
        copy "platforms\android\app\build\outputs\apk\release\app-release-unsigned.apk" "output\娇娇-v1.0.0-release-unsigned.apk" >nul
        :signed
    ) else (
        echo.
        echo 未找到签名密钥，Release版本未签名。
        echo 如需签名，请先生成密钥库:
        echo keytool -genkey -v -keystore jiaojiao.keystore -alias jiaojiao -keyalg RSA -keysize 2048 -validity 10000
        copy "platforms\android\app\build\outputs\apk\release\app-release-unsigned.apk" "output\娇娇-v1.0.0-release-unsigned.apk" >nul
    )
)

echo.
echo ==========================================
echo 构建完成！
echo ==========================================
echo 输出目录: output\
dir output\
echo.
pause
