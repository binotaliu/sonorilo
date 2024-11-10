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
SwitchAudioSource -s "Mac mini Speakers" > /dev/null

# 3. Save current volume
CURRENT_VOLUME=$(osascript -e "output volume of (get volume settings)")

# 4. Adjust volume
osascript -e "set volume output volume $TARGET_VOLUME"

# 5. Switch back audio source
SwitchAudioSource -s "$CURRENT_SOURCE" > /dev/null

# 6. Play audio, and lock output to Mac mini Speaker
DEVICE_INDEX=$(ffmpeg -i "$AUDIO_FILE" -f audiotoolbox -list_devices 1 -t 0.1 -y /dev/null 2>&1 | grep "Mac mini Speakers" | awk -F '[][]' '{print $4}')
ffmpeg -i "$AUDIO_FILE" -f audiotoolbox -audio_device_index "$DEVICE_INDEX" -loglevel error -

# 7. Switch back to Mac mini Speaker
SwitchAudioSource -s "Mac mini Speakers" > /dev/null

# 8. Set volume back
osascript -e "set volume output volume $CURRENT_VOLUME"

# 9. Switch back audio source
SwitchAudioSource -s "$CURRENT_SOURCE" > /dev/null

