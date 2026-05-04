@echo off
setlocal
cd /d "%~dp0"

echo === Kanban Deploy ===
echo Repo: %CD%
echo.

REM --- Locate git ---
REM 1) Try git already on PATH
where git >nul 2>nul
if %errorlevel%==0 goto have_git

REM 2) Look for GitHub Desktop's bundled git
for /d %%i in ("%LocalAppData%\GitHubDesktop\app-*") do (
  if exist "%%i\resources\app\git\cmd\git.exe" set "PATH=%%i\resources\app\git\cmd;%PATH%"
)
where git >nul 2>nul
if %errorlevel%==0 goto have_git

REM 3) Look for standalone Git for Windows
if exist "C:\Program Files\Git\cmd\git.exe" set "PATH=C:\Program Files\Git\cmd;%PATH%"
where git >nul 2>nul
if %errorlevel%==0 goto have_git

echo.
echo ERROR: Could not find git.
echo.
echo Please either:
echo   1) Use GitHub Desktop GUI to commit + push (no fix needed), OR
echo   2) Install Git for Windows from https://git-scm.com/download/win
echo.
pause
exit /b 1

:have_git
for /f "tokens=*" %%g in ('where git') do echo Using git at: %%g
echo.

git status --short
echo.

set /p MSG="Commit message (Enter for default): "
if "%MSG%"=="" set MSG=Update kanban (%date% %time%)

echo.
echo Committing: %MSG%
git add -A
git commit -m "%MSG%"
if errorlevel 1 (
  echo.
  echo Nothing to commit ^(or commit failed^). Trying to push anyway...
)

echo.
echo Pushing to GitHub...
git push
if errorlevel 1 (
  echo.
  echo Push failed. Check your network/auth and try again.
  pause
  exit /b 1
)

echo.
echo === Done ===
echo GitHub Pages will rebuild in 1-2 minutes.
echo URL: https://xijie2013.github.io/life-work-kanban/
echo.
pause
