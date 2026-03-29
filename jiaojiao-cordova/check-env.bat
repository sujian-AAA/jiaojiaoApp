@echo off
chcp 65001
cls
echo.
echo ==========================================
echo 环境检查工具
echo ==========================================
echo.

set ALL_OK=1

echo [*] 检查Node.js...
node -v >nul 2>&1
if errorlevel 1 (
    echo     [X] 未安装 Node.js
    set ALL_OK=0
) else (
    for /f "tokens=*" %%a in ('node -v') do echo     [OK] Node.js %%a
)

echo.
echo [*] 检查npm...
npm -v >nul 2>&1
if errorlevel 1 (
    echo     [X] npm 不可用
    set ALL_OK=0
) else (
    for /f "tokens=*" %%a in ('npm -v') do echo     [OK] npm %%a
)

echo.
echo [*] 检查Java...
java -version >nul 2>&1
if errorlevel 1 (
    echo     [X] 未安装 Java
    set ALL_OK=0
) else (
    echo     [OK] Java 已安装
)

echo.
echo [*] 检查JAVA_HOME...
if "%JAVA_HOME%"=="" (
    echo     [X] JAVA_HOME 未设置
    set ALL_OK=0
) else (
    echo     [OK] JAVA_HOME = %JAVA_HOME%
)

echo.
echo [*] 检查Android SDK...
if "%ANDROID_HOME%"=="" (
    if "%ANDROID_SDK_ROOT%"=="" (
        echo     [X] ANDROID_HOME 未设置
        set ALL_OK=0
    ) else (
        echo     [OK] ANDROID_SDK_ROOT = %ANDROID_SDK_ROOT%
    )
) else (
    echo     [OK] ANDROID_HOME = %ANDROID_HOME%
)

echo.
echo [*] 检查Cordova...
cordova -v >nul 2>&1
if errorlevel 1 (
    echo     [X] 未安装 Cordova
    set ALL_OK=0
) else (
    for /f "tokens=*" %%a in ('cordova -v') do echo     [OK] Cordova %%a
)

echo.
echo ==========================================
if %ALL_OK%==1 (
    echo 环境检查通过！可以开始构建。
    echo.
    echo 现在可以运行 build-simple.bat 开始构建APK。
) else (
    echo 环境检查未通过！
    echo.
    echo 请按照"快速开始.md"中的说明安装必要软件。
)
echo ==========================================
echo.

pause
