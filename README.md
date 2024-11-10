# Sonorilo ⏰

[![GPL-3.0 License](https://img.shields.io/badge/License-GPL%20v3.0-blue.svg)](https://www.gnu.org/licenses/gpl-3.0.en.html)
![Made with Love](https://img.shields.io/badge/Made%20with-%E2%9D%A4-red)

**Sonorilo** 是我用來在自己的 mac mini 上播放「鐘聲」的工具。鐘聲就像學校或工廠的鐘聲，能讓你在居家辦公時也能遵守固定的作息。\
**Sonorilo** 是一個 Esperanto 詞，他的發音是 /sonoˈrilo/，他是由兩個詞組成的：「sonor-」（聲音）和「-ilo」（工具）。

----

#### Esperanto

**Sonorilo** estas ilo por ludigi "sonorilojn" en mia Mac Mini. Sonoriloj similas al tiuj en lernejoj aŭ fabrikoj, kaj ili helpas vin sekvi regulan tagordon dum hejma laboro.\
**Sonorilo** estas Esperanto-vorto, kies prononco estas /sonoˈrilo/, kaj ĝi konsistas el du vortoj: "sonor-" (sono) kaj "-ilo" (ilo). Se vi povas regi ĉi tiun frazon, vi jam estas bona Esperanto-parolanto!

----

#### English

**Sonorilo** is a tool I use to play "bells" on my Mac Mini. Bells are like those in schools or factories, helping you maintain a regular schedule while working from home.\
**Sonorilo** is an Esperanto word, pronounced /sonoˈrilo/, and it consists of two words: "sonor-" (sound) and "-ilo" (tool).

----

#### 日本語

**Sonorilo** は、Mac Mini で「ベル」を再生するためのツールです。ベルは学校や工場のベルのように、在宅勤務中も規則的なスケジュールを維持するのに役立ちます。\
**Sonorilo** はエスペラント語の単語で、発音は /sonoˈrilo/ で、2つの単語「sonor-」（音）と「-ilo」（ツール）から構成されています。

----


## Features
- 📅 **Customizable Scheduling**: Uses a YAML configuration file to define sound alerts and playback times.\
- 🕰 **Flexible Timing**: Uses `launchd` to check the schedule every minute, ensuring precise sound playback.

## Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/binotaliu/sonorilo.git
   ```

2. **Install Deno** (if not already installed):
   ```bash
   curl -fsSL https://deno.land/install.sh | sh
   ```

3. **Create a YAML configuration file**: Define your schedule in `schedule.yaml` with the desired sound files, times, and playback options. Example:
   ```yaml
   - time: "9:30"
     sound: "westminster-chimes.m4a"
     type: "normal"
     volume: 7
   - time: "10:00"
     sound: "amaryllis.opus"
     type: "bluetooth"
   ```
   Sounds live in `sounds/` directory. You can put anything that ffmpeg supports.

4. **Configure launchd**: Copy `org.binota.sonorilo.plist` to `~/Library/LaunchAgents/` and adjust paths and times as needed.

5. **Load the `launchd` job**:
   ```bash
   launchctl load ~/Library/LaunchAgents/org.binota.sonorilo.plist
   ```

## Usage

### YAML Configuration
The `schedule.yaml` file defines each scheduled task. Each entry includes:
- `time`: The time to play the sound, formatted as `HH:MM`.
- `sound`: The filename of the sound file to play (stored in the `sounds/` folder).
- `type`: Playback type, either `normal` or `bluetooth`.
- `volume` (optional): Set volume level (0-100) for `normal` playback.

### Example Schedule File
```yaml
- time: "9:30"
  sound: "westminster-chimes.ogg"
  type: "normal"
  volume: 7
- time: "10:00"
  sound: "amaryllis.ogg"
  type: "bluetooth"
```

### Script Execution
The Deno script `schedule.js` reads the `schedule.yaml` configuration file, checks the current time every minute, and plays the corresponding sound through either `play.sh` or `play-with-bluetooth.sh` based on the configuration.

## License
This project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html).

---

Happy scheduling! Let the bells keep you on track ⏲️.
