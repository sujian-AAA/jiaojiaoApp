@echo off
chcp 65001
cls
echo.
echo ==========================================
echo 娇娇 Android应用构建脚本
echo ==========================================
echo.

REM 设置工作目录
cd /d "%~dp0"

echo 当前目录: %CD%
echo.

REM 检查Node.js
echo [*] 检查Node.js...
node -v >nul 2>&1
if errorlevel 1 (
    echo.
    echo [错误] 未找到Node.js！
    echo.
    echo 请先安装Node.js:
    echo 1. 访问 https://nodejs.org/
    echo 2. 下载并安装 LTS 版本
    echo 3. 重新运行此脚本
    echo.
    pause
    exit /b 1
)
echo     Node.js版本: 
for /f "tokens=*" %%a in ('node -v') do echo     %%a

REM 检查Java
echo.
echo [*] 检查Java...
java -version >nul 2>&1
if errorlevel 1 (
    echo.
    echo [错误] 未找到Java！
    echo.
    echo 请先安装Java JDK 11或17:
    echo 1. 访问 https://adoptium.net/
    echo 2. 下载并安装 JDK 17 (LTS)
    echo 3. 设置 JAVA_HOME 环境变量
    echo 4. 重新运行此脚本
    echo.
    pause
    exit /b 1
)
echo     Java已安装

REM 检查Android SDK
echo.
echo [*] 检查Android SDK...
if "%ANDROID_HOME%"=="" (
    if "%ANDROID_SDK_ROOT%"=="" (
        echo.
        echo [错误] 未找到Android SDK！
        echo.
        echo 请先安装Android Studio:
        echo 1. 访问 https://developer.android.com/studio
        echo 2. 下载并安装 Android Studio
        echo 3. 在Android Studio中安装SDK (API 21-34)
        echo 4. 设置 ANDROID_HOME 环境变量
        echo    例如: ANDROID_HOME=C:\Users\你的用户名\AppData\Local\Android\Sdk
        echo 5. 重新运行此脚本
        echo.
        pause
        exit /b 1
    )
)
echo     Android SDK: %ANDROID_HOME%%ANDROID_SDK_ROOT%

REM 安装Cordova
echo.
echo [*] 检查Cordova...
call cordova -v >nul 2>&1
if errorlevel 1 (
    echo     Cordova未安装，正在安装...
    call npm install -g cordova
    if errorlevel 1 (
        echo [错误] Cordova安装失败！
        pause
        exit /b 1
    )
)
for /f "tokens=*" %%a in ('cordova -v') do echo     Cordova版本: %%a

REM 安装项目依赖
echo.
echo [*] 安装项目依赖...
call npm install
if errorlevel 1 (
    echo [错误] 依赖安装失败！
    pause
    exit /b 1
)

REM 添加Android平台
echo.
echo [*] 配置Android平台...
if not exist "platforms\android" (
    echo     添加Android平台 (首次运行，可能需要几分钟)...
    call cordova platform add android@12.0.0
    if errorlevel 1 (
        echo [错误] 添加Android平台失败！
        pause
        exit /b 1
    )
) else (
    echo     Android平台已存在
)

REM 构建APK
echo.
echo [*] 构建APK...
echo     正在构建Debug版本 (请耐心等待)...
call cordova build android
if errorlevel 1 (
    echo.
    echo [错误] 构建失败！
    echo.
    echo 常见解决方法:
    echo 1. 检查Android SDK是否正确安装
    echo 2. 运行: cordova clean
    echo 3. 删除 platforms 文件夹后重试
    echo 4. 检查网络连接（需要下载Gradle依赖）
    echo.
    pause
    exit /b 1
)

REM 复制APK
echo.
echo [*] 复制APK到输出目录...
if not exist "output" mkdir output
copy "platforms\android\app\build\outputs\apk\debug\app-debug.apk" "output\娇娇-v1.0.0-debug.apk" >nul
echo     输出: output\娇娇-v1.0.0-debug.apk

echo.
echo ==========================================
echo 构建成功！
echo ==========================================
echo.
echo 安装方法:
echo 1. 将APK文件传输到手机
echo 2. 在手机上点击安装
echo 3. 如提示"未知来源"，请在设置中允许
echo.
echo 或者使用ADB安装:
echo adb install output\娇娇-v1.0.0-debug.apk
echo.

pause
