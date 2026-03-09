#!/usr/bin/env bash
set -euo pipefail

battery=""
while IFS= read -r line; do
  case "$line" in
    *battery*)
      battery="$line"
      break
      ;;
  esac
done < <(upower -e)

if [ -z "$battery" ]; then
  exit 0
fi

state=$(upower -i "$battery" | awk -F': *' '/state/ {print $2; exit}')
percent=$(upower -i "$battery" | awk -F': *' '/percentage/ {gsub(/%/,"",$2); print $2; exit}')

if [ "$state" != "discharging" ]; then
  exit 0
fi

warn=20
critical=10

level="ok"
if [ "$percent" -le "$critical" ]; then
  level="critical"
elif [ "$percent" -le "$warn" ]; then
  level="warning"
fi

cache="$HOME/.cache/battery-warn"
last=""
if [ -f "$cache" ]; then
  last=$(cat "$cache" 2>/dev/null || true)
fi

if [ "$level" != "ok" ] && [ "$level" != "$last" ]; then
  urgency="low"
  title="Battery low"
  message="${percent}% remaining"
  if [ "$level" = "critical" ]; then
    urgency="critical"
    title="Battery critical"
  fi
  notify-send -u "$urgency" -i battery "$title" "$message"
  echo "$level" > "$cache"
fi
