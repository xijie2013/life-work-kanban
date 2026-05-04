@echo off
setlocal
cd /d "%~dp0"

echo === Kanban Deploy ===
echo Repo: %CD%
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
