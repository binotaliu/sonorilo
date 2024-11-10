#!/bin/bash

# Check if the audio file path is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <audio file path> [volume (0-100)]"
    exit 1
fi

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin"

AUDIO_FILE="$1"
TARGET_VOLUME=${2:-50}  # Set playback volume, default is 50%

# 1. Check if the Bluetooth headset is connected and get DEVICE_INDEX
DEVICE_INDEX=$(ffmpeg -i "$AUDIO_FILE" -f audiotoolbox -list_devices 1 -t 0.1 -y /dev/null 2>&1 | grep "48-73-CB-D5-2A-39:output" | awk -F '[][]' '{print $4}')

# 2. If DEVICE_INDEX is empty, display a message and switch to Mac mini Speakers
if [ -z "$DEVICE_INDEX" ]; then
    echo "Bluetooth headset not connected. Using Mac mini Speakers instead."
    DEVICE_INDEX=$(ffmpeg -i "$AUDIO_FILE" -f audiotoolbox -list_devices 1 -t 0.1 -y /dev/null 2>&1 | grep "Mac mini Speakers" | awk -F '[][]' '{print $4}')
fi

# 3. Adjust volume
CURRENT_VOLUME=$(osascript -e "output volume of (get volume settings)")
osascript -e "set volume output volume $TARGET_VOLUME"

# 4. Play audio file
ffmpeg -i "$AUDIO_FILE" -f audiotoolbox -audio_device_index "$DEVICE_INDEX" -loglevel error -

# 5. Restore original volume
osascript -e "set volume output volume $CURRENT_VOLUME"

echo "Playback completed."

