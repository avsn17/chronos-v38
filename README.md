# 🛰️ Chronos V38 — IROH Sanctuary

A cosmic Pomodoro timer and productivity station built for focused work sessions, music, and terminal-based mindfulness.

---

## ✨ Features

- **Pomodoro Timer** — customizable focus sessions with session tracking
- **IROH Sanctuary UI** — immersive animated sky/sun interface with rising sun
- **Element Themes** — Void, Fire, Water, Earth, Air atmospheres
- **Neural Streams** — YouTube music auto-plays on session complete
- **Pilot Stats** — session history saved to localStorage, exportable as `mission_log.json`
- **Stats Dashboard** — visual session overview via `stats.html`
- **IROH Wisdom Engine** — quotes from Uncle Iroh on demand
- **Music Watcher** — local file playback + signal protocol via `music_watcher.py`
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

Open `index.html` in your browser — no build step required.
```bash
open index.html        # macOS
xdg-open index.html    # Linux
# or use Live Server in VS Code / Codespaces
```

### Optional: start background services
```bash
# Hydration & break reminders
python3 time_interval.py &

# Music signal watcher (for local file playback)
python3 music_watcher.py &
mkdir -p data && cp ~/your_music.mp3 data/focus_music.mp3
```

---

## 📁 File Structure
```
chronos-v38/
├── index.html           # Main IROH Sanctuary UI
├── script.js            # Core timer, session logic, all keyboard shortcuts
├── style.css            # All styles and themes
├── music_ytb.js         # YouTube stream handler + signal protocol
├── music_watcher.py     # Local music playback server (port 8765)
├── music.py             # Music CLI (play/stop/pause/resume/status)
├── time_interval.py     # Hydration & break reminder daemon
├── stats.html           # Session stats dashboard
├── iroh_sanctuary.html  # Alternate sanctuary view
├── iroh.bot             # IROH bot config
├── iroh_bot.sh          # Bot launcher
└── save_all.sh          # Backup utility
```

---

## ⌨️ Keyboard Shortcuts

| Key | Action |
|-----|--------|
| `Space` | Pause / Resume warp |
| `C` | Wisdom Chat — consult Iroh |
| `S` | Stats Leaderboard |
| `A` | Config / Settings |
| `M` | Toggle Music Signal on/off |
| `O` | Cycle color theme |
| `N` | Save & New Session |
| `Q` | Save & Quit |
| `R` | Reset timer |
| `Esc` | Close any modal |

---

## 🎵 Music Signal Protocol

`music_watcher.py` runs a local server on port `8765` and accepts these signals from the browser:

| Signal | Action |
|--------|--------|
| `PLAY_NEXT` | Start / advance playback |
| `STOP` | Stop playback |
| `PAUSE` | Freeze playback |
| `RESUME` | Resume playback |
| `IDLE` | No action |
```bash
python3 music.py play     # send PLAY_NEXT
python3 music.py stop     # send STOP
python3 music.py status   # check watcher
python3 music.py list     # list tracks in data/
```

---

## 👾 Built by

**avsn17** — Pink Station, Cosmic Kirbs Division 🌸
