# 🛰️ Chronos V38 — IROH Sanctuary

A cosmic Pomodoro timer and productivity station built for focused work sessions, music, and terminal-based mindfulness.

---

## ✨ Features

- **Pomodoro Timer** — customizable focus sessions with session tracking
- **IROH Sanctuary UI** — immersive animated sky/sun interface (`index.html`)
- **Element Themes** — Void, Fire, Water, Earth, Air atmospheres
- **Neural Streams** — YouTube music auto-plays on session complete
- **Pilot Stats** — session history saved to localStorage, exportable as `mission_log.json`
- **Stats Dashboard** — visual session overview via `stats.html`
- **Command Palette** — `⌘K` for all commands
- **IROH Wisdom Engine** — quotes from Uncle Iroh on demand
- **Time Interval Tracker** — hydration and break reminders via `time_interval.py`

---

## 🚀 Getting Started

### Prerequisites
```bash
node >= 18
python3
```

### Install
```bash
git clone https://github.com/avsn17/chronos-v38.git
cd chronos-v38
```

### Run

Open `index.html` directly in your browser — no build step required.
```bash
open index.html        # macOS
xdg-open index.html    # Linux
```

---

## 📁 File Structure
```
chronos-v38/
├── index.html          # Main IROH Sanctuary UI
├── iroh_sanctuary.html # Alternate sanctuary view
├── script.js           # Core timer + session logic
├── style.css           # Shared styles
├── stats.html          # Session stats dashboard
├── music.py            # Music player backend (optional)
├── music_ytb.js        # YouTube stream handler
├── time_interval.py    # Hydration/break reminders
├── iroh.bot            # IROH bot config
├── iroh_bot.sh         # Bot launcher script
└── save_all.sh         # Backup/save utility
```

---

## 🎮 Usage

| Action | How |
|--------|-----|
| Start session | Click **ENGAGE WARP** or press `Space` |
| Pause / abort | Click **ABORT WARP** or press `Space` |
| Reset timer | Press `R` |
| Consult Iroh | Press `I` |
| New mission | Press `N` |
| Command palette | `⌘K` / `Ctrl+K` |
| Switch streams | Keys `1`–`5` |
| Change element | Keys `F` `W` `E` `A` `V` |
| Export flight log | Right panel → **EXPORT** |

---

## 👾 Built by

**avsn17** — Pink Station, Cosmic Kirbs Division 🌸
