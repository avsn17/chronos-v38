# chronos-v38
# 🛰️ Chronos V38 — IROH Sanctuary

A cosmic Pomodoro timer and productivity station built for focused work sessions, music, and terminal-based mindfulness.

---

## ✨ Features

- **Pomodoro Timer** — 25-minute focus sessions with session tracking and XP
- **IROH Sanctuary UI** — immersive animated sky/sun interface (`index.html`)
- **Music Player** — YouTube-based stream integration via `music.py` and `music_ytb.js`
- **Pilot Stats** — session history saved to `pilot_history.json` and `stats_history.json`
- **Stats Dashboard** — visual session overview via `stats.html`
- **Cosmic Widget** — terminal notification system with Kirby animations
- **Time Interval Tracker** — hydration and break reminders via `time_interval.py`
- **IROH Bot** — companion bot with history logging (`iroh.bot`, `bot_history.log`)

---

## 🚀 Getting Started

### Prerequisites

```bash
node >= 18
python3
mpv (for music playback)
```

### Install

```bash
git clone https://github.com/avsn17/chronos-v38.git
cd chronos-v38
npm install
pip install -r requirements.txt   # if present
```

### Write

poyo

wid

---

## 📁 File Structure

```
chronos-v38/
├── index.html              # Main IROH Sanctuary UI
├── iroh_sanctuary.html     # Alternate sanctuary view
├── script.py               # Core timer + session logic
├── music.py                # Music player backend
├── music_ytb.js            # YouTube stream handler
├── time_interval.py        # Hydration/break reminders
├── iroh.bot                # IROH bot config
├── iroh_bot.sh             # Bot launcher script
├── stats.html              # Session stats dashboard
├── stats_history.json      # Historical session data
├── pilot_history.json      # Per-pilot flight log
├── bot_history.log         # IROH bot interaction log
├── style.css               # Shared styles
├── diagnose.sh             # Diagnostics script
└── save_all.sh             # Backup/save utility
```

---

## 🎮 Usage

- **Start session** — click the timer or run `script.py`
- **Music** — streams play automatically on session start via `mpv`
- **Stats** — open `stats.html` in browser to review your sessions
- **Widget** — run `python3 widget.py` (if present) in a split terminal for live Kirby notifications

---

## 👾 Built by

**avsn17** — Pink Station, Cosmic Kirbs Division 🌸
