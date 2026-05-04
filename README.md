# Life Work Kanban

Personal life-work kanban with GitHub Gist sync, hosted on GitHub Pages.

- **Frontend**: static HTML/CSS/JS, served from GitHub Pages
- **Data**: stored in a private GitHub Gist (read/write via REST API)
- **Auth**: per-device Personal Access Token, stored in browser localStorage
- **Mobile**: responsive with tab layout, installable as PWA

## First-time setup on a new device

1. Open the app URL in a browser
2. Click the ⚙ button (or settings will pop automatically)
3. Paste your Gist ID and Personal Access Token (token must have `gist` scope)
4. Done — data syncs across all devices configured this way

## Local development

After Claude (or you) edits `index.html`, run `deploy.bat` to commit and push. GitHub Pages rebuilds in 1-2 minutes.

## Files

| File | Purpose |
|---|---|
| `index.html` | The app (UI + Gist sync logic) |
| `manifest.json` | PWA metadata |
| `icon.svg` | App icon (used by PWA + browser tab) |
| `deploy.bat` | Convenience: `git add -A && git commit && git push` |
| `.gitignore` | Excludes `.kanban/` (token storage) and editor noise |
