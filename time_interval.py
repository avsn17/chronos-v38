#!/usr/bin/env python3
"""
time_interval.py — Hydration & Break Reminders
================================================
Usage:
  python3 time_interval.py &          # run in background, default 60min water + 25min break
  python3 time_interval.py --water 30 --break 25
"""
import time, sys, subprocess, threading

WATER_MIN = 60
BREAK_MIN = 25

for i, arg in enumerate(sys.argv):
    if arg == '--water' and i+1 < len(sys.argv): WATER_MIN = int(sys.argv[i+1])
    if arg == '--break' and i+1 < len(sys.argv): BREAK_MIN = int(sys.argv[i+1])

def notify(title, msg):
    try:
        subprocess.run(['notify-send', title, msg], capture_output=True)
    except Exception:
        print(f'[{title}] {msg}')

def water_loop():
    while True:
        time.sleep(WATER_MIN * 60)
        notify('IROH SAYS', 'Drink water, Pilot. Even masters must hydrate.')
        print(f'[HYDRATION] Water reminder sent.')

def break_loop():
    while True:
        time.sleep(BREAK_MIN * 60)
        notify('IROH SAYS', 'Rest your eyes. A moment of stillness sharpens the mind.')
        print(f'[BREAK] Break reminder sent.')

print(f'[TIME INTERVAL] Water: every {WATER_MIN}min  Break: every {BREAK_MIN}min')
threading.Thread(target=water_loop, daemon=True).start()
threading.Thread(target=break_loop, daemon=True).start()

try:
    while True: time.sleep(3600)
except KeyboardInterrupt:
    print('[TIME INTERVAL] Stopped.')
