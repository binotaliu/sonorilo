#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <audio-file> [Volumn (0-100)]"
    exit 1
fi

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

AUDIO_FILE="$1"

TARGET_VOLUME=${2:-30}

if [ "$TARGET_VOLUME" -lt 0 ] || [ "$TARGET_VOLUME" -gt 100 ]; then
    echo "Volume must between 0 to 100"
    exit 1
fi

# 1. Save current audio source
CURRENT_SOURCE=$(SwitchAudioSource -c)

# 2. Switch to Mac mini Speaker
if [ "$CURRENT_SOURCE" != "Redmi Buds 5 Pro" ]; then
  SwitchAudioSource -s "Mac mini Speakers" > /dev/null
fi

# 3. Save current volume
CURRENT_VOLUME=$(osascript -e "output volume of (get volume settings)")

# 4. Adjust volume
if [ "$CURRENT_SOURCE" != "Redmi Buds 5 Pro" ]; then
  osascript -e "set volume output volume $TARGET_VOLUME"
fi

# 5. Switch back audio source
if [ "$CURRENT_SOURCE" != "Redmi Buds 5 Pro" ]; then
  SwitchAudioSource -s "$CURRENT_SOURCE" > /dev/null
fi

# 6. Play audio, and lock output to Mac mini Speaker
if [ "$CURRENT_SOURCE" != "Redmi Buds 5 Pro" ]; then
  DEVICE_INDEX=$(ffmpeg -i "$AUDIO_FILE" -f audiotoolbox -list_devices 1 -t 0.1 -y /dev/null 2>&1 | grep "Mac mini Speakers" | awk -F '[][]' '{print $4}')
  ffmpeg -i "$AUDIO_FILE" -f audiotoolbox -audio_device_index "$DEVICE_INDEX" -loglevel error -
else
  ffmpeg -i "$AUDIO_FILE" -f audiotoolbox -loglevel error -
fi

# 7. Switch back to Mac mini Speaker
if [ "$CURRENT_SOURCE" != "Redmi Buds 5 Pro" ]; then
  SwitchAudioSource -s "Mac mini Speakers" > /dev/null
fi

# 8. Set volume back
if [ "$CURRENT_SOURCE" != "Redmi Buds 5 Pro" ]; then
  osascript -e "set volume output volume $CURRENT_VOLUME"
fi

# 9. Switch back audio source
if [ "$CURRENT_SOURCE" != "Redmi Buds 5 Pro" ]; then
  SwitchAudioSource -s "$CURRENT_SOURCE" > /dev/null
fi

