@echo off
setlocal enabledelayedexpansion
color 0A
title CBT Exam System - Control Panel

:MENU
cls
echo ========================================
echo   CBT Exam System - Control Panel
echo ========================================
echo.
echo [1] Start Servers
echo [2] Stop Servers
echo [3] Restart Servers
echo [4] View Server Status
echo [5] Open Admin Panel
echo [6] Show Network Info
echo [7] Exit
echo.
set /p CHOICE="Enter your choice (1-7): "

if "%CHOICE%"=="1" goto START_SERVERS
if "%CHOICE%"=="2" goto STOP_SERVERS
if "%CHOICE%"=="3" goto RESTART_SERVERS
if "%CHOICE%"=="4" goto VIEW_STATUS
if "%CHOICE%"=="5" goto OPEN_BROWSER
if "%CHOICE%"=="6" goto SHOW_NETWORK
if "%CHOICE%"=="7" goto EXIT
goto MENU

:START_SERVERS
cls
echo ========================================
echo   Starting CBT Exam System
echo ========================================
echo.

:CHECK_NODE
echo [1/7] Checking Node.js installation...
node --version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo ERROR: Node.js is not installed!
    echo Please install Node.js from https://nodejs.org/
    pause
    goto MENU
)
for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo       Node.js %NODE_VERSION%: OK
echo.

:CHECK_ENV
echo [2/7] Checking environment files...
if not exist "%~dp0exam_management\.env.local" (
    color 0E
    echo WARNING: exam_management\.env.local not found!
    echo Creating from template...
    copy "%~dp0exam_management\.env.example" "%~dp0exam_management\.env.local" >nul 2>&1
    if %errorlevel% neq 0 (
        color 0C
        echo ERROR: Could not create .env.local file!
        echo Please create it manually from .env.example
        pause
        goto MENU
    )
    echo       Created exam_management\.env.local
)

if not exist "%~dp0student\.env.local" (
    color 0E
    echo WARNING: student\.env.local not found!
    echo Creating from template...
    copy "%~dp0student\.env.example" "%~dp0student\.env.local" >nul 2>&1
    if %errorlevel% neq 0 (
        color 0C
        echo ERROR: Could not create .env.local file!
        pause
        goto MENU
    )
    echo       Created student\.env.local
)
color 0A
echo       Environment files: OK
echo.

:CHECK_PORTS
echo [3/7] Checking port availability...
netstat -an | find ":3000 " | find "LISTENING" >nul 2>&1
if %errorlevel% equ 0 (
    color 0E
    echo WARNING: Port 3000 is already in use!
    echo Another application might be using it.
    set /p CONTINUE="Continue anyway? (Y/N): "
    if /i not "!CONTINUE!"=="Y" goto MENU
    color 0A
)

netstat -an | find ":3001 " | find "LISTENING" >nul 2>&1
if %errorlevel% equ 0 (
    color 0E
    echo WARNING: Port 3001 is already in use!
    set /p CONTINUE="Continue anyway? (Y/N): "
    if /i not "!CONTINUE!"=="Y" goto MENU
    color 0A
)
echo       Ports 3000, 3001: Available
echo.

:CHECK_DEPENDENCIES
echo [4/7] Checking dependencies...
if not exist "%~dp0exam_management\node_modules\" (
    echo       Installing Exam Management dependencies...
    cd /d "%~dp0exam_management"
    call npm install --silent
    if %errorlevel% neq 0 (
        color 0C
        echo ERROR: Failed to install dependencies!
        pause
        goto MENU
    )
)

if not exist "%~dp0student\node_modules\" (
    echo       Installing Student Portal dependencies...
    cd /d "%~dp0student"
    call npm install --silent
    if %errorlevel% neq 0 (
        color 0C
        echo ERROR: Failed to install dependencies!
        pause
        goto MENU
    )
)
echo       Dependencies: OK
echo.

:CHECK_MYSQL
echo [5/7] Checking MySQL/WampServer...
netstat -an | find ":3306" >nul 2>&1
if %errorlevel% neq 0 (
    color 0E
    echo WARNING: MySQL not detected on port 3306!
    echo Please ensure WampServer is running (Green icon^)
    echo.
    set /p CONTINUE="Continue anyway? (Y/N): "
    if /i not "!CONTINUE!"=="Y" goto MENU
    color 0A
) else (
    echo       MySQL: Running
)
echo.

:START_APPS
echo [6/6] Starting servers...
echo.
echo Starting Exam Management System (Port 3000^)...
start "Exam Management Server" cmd /k "cd /d "%~dp0exam_management" && npm run dev -- -H 0.0.0.0 -p 3000"

timeout /t 3 /nobreak >nul

echo Starting Student Portal (Port 3001^)...
start "Student Portal Server" cmd /k "cd /d "%~dp0student" && npm run dev -- -H 0.0.0.0 -p 3001"

echo.
echo ========================================
echo   Servers Starting...
echo ========================================
echo.
echo Waiting for initialization...
timeout /t 8 /nobreak >nul

:HEALTH_CHECK
echo.
echo Performing health checks...

curl -s http://localhost:3000/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Exam Management: http://localhost:3000
) else (
    echo [WAIT] Exam Management: Still starting...
)

curl -s http://localhost:3001/api/health >nul 2>&1
if %errorlevel% equ 0 (
    echo [OK] Student Portal: http://localhost:3001
) else (
    echo [WAIT] Student Portal: Still starting...
)

echo.
echo ========================================
echo   Network Access Information
echo ========================================
echo.
echo Using Hostname (Recommended^):
echo   Admin:   http://devwiz:3000
echo   Student: http://devwiz:3001
echo.
echo Using IP Address (if hostname doesn't work^):
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set IP=%%a
    set IP=!IP:~1!
    echo   Admin:   http://!IP!:3000
    echo   Student: http://!IP!:3001
    echo.
)
echo ========================================
echo.
color 0A
pause
goto MENU

:STOP_SERVERS
cls
echo ========================================
echo   Stopping Servers
echo ========================================
echo.
echo Closing server windows...
taskkill /FI "WindowTitle eq Exam Management Server*" /F >nul 2>&1
taskkill /FI "WindowTitle eq Student Portal Server*" /F >nul 2>&1
echo.
echo Servers stopped!
timeout /t 2 /nobreak >nul
goto MENU

:RESTART_SERVERS
call :STOP_SERVERS
timeout /t 2 /nobreak >nul
goto START_SERVERS

:VIEW_STATUS
cls
echo ========================================
echo   Server Status
echo ========================================
echo.
netstat -an | find ":3000 " | find "LISTENING" >nul 2>&1
if %errorlevel% equ 0 (
    echo [RUNNING] Exam Management - Port 3000
) else (
    echo [STOPPED] Exam Management - Port 3000
)

netstat -an | find ":3001 " | find "LISTENING" >nul 2>&1
if %errorlevel% equ 0 (
    echo [RUNNING] Student Portal - Port 3001
) else (
    echo [STOPPED] Student Portal - Port 3001
)

netstat -an | find ":3306" >nul 2>&1
if %errorlevel% equ 0 (
    echo [RUNNING] MySQL - Port 3306
) else (
    echo [STOPPED] MySQL - Port 3306
)
echo.
pause
goto MENU

:OPEN_BROWSER
start http://devwiz:3000
echo Browser opened!
timeout /t 2 /nobreak >nul
goto MENU

:SHOW_NETWORK
cls
echo ========================================
echo   Network Access Information
echo ========================================
echo.
echo Using Hostname (Recommended^):
echo   Admin:   http://devwiz:3000
echo   Student: http://devwiz:3001
echo.
echo Using IP Address (if hostname doesn't work^):
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set IP=%%a
    set IP=!IP:~1!
    echo   Admin:   http://!IP!:3000
    echo   Student: http://!IP!:3001
    echo.
)
echo ========================================
echo.
pause
goto MENU

:EXIT
cls
echo.
echo Thank you for using CBT Exam System!
echo.
timeout /t 2 /nobreak >nul
exit
