@echo off
echo ====================================
echo CBT Exam Management System Startup
echo ====================================
echo.
echo Starting both applications...
echo.

REM Start Exam Management System (Port 3000)
echo [1/2] Starting Exam Management System on port 3000...
start "Exam Management - Port 3000" cmd /k "cd /d "%~dp0exam_management" && npm run dev"

REM Wait 3 seconds
timeout /t 3 /nobreak > nul

REM Start Student Portal (Port 3001)
echo [2/2] Starting Student Portal on port 3001...
start "Student Portal - Port 3001" cmd /k "cd /d "%~dp0student" && npm run dev"

echo.
echo ====================================
echo Both applications are starting!
echo ====================================
echo.
echo Exam Management: http://localhost:3000
echo Student Portal:  http://localhost:3001
echo.
echo Health Checks:
echo - Admin:   http://localhost:3000/api/health
echo - Student: http://localhost:3001/api/health
echo.
echo To access from other devices on LAN:
echo Replace 'localhost' with your server IP address
echo.
echo Press any key to exit this window...
pause > nul
