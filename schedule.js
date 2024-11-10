import { parse } from "https://deno.land/std@0.112.0/encoding/yaml.ts";
import { dirname, fromFileUrl, join } from "https://deno.land/std@0.112.0/path/mod.ts";

// 獲取當前 script 的路徑
const __dirname = dirname(fromFileUrl(import.meta.url));

// 讀取 YAML 檔案，設置為相對於 script 的路徑
const yamlFilePath = join(__dirname, "schedule.yaml");
const yamlContent = await Deno.readTextFile(yamlFilePath);
const schedules = parse(yamlContent);

// 獲取當前時間
const now = new Date();
const currentHour = now.getHours();
const currentMinute = now.getMinutes();

// 檢查每個排程，確認是否符合當前時間
for (const task of schedules) {
  const [hour, minute] = task.time.split(":").map(Number);

  if (hour === currentHour && minute === currentMinute) {
    // 構建音檔的相對路徑
    const soundFilePath = join(__dirname, "sounds", task.sound);

    const soundVolume = task.volume?.toString?.()

    const params = [soundFilePath, soundVolume].filter(i => i).map(String)

    // 執行對應的播放指令
    if (task.type === "bluetooth") {
      await Deno.run({
        cmd: [join(__dirname, "play-with-bluetooth.sh"), ...params],
      }).status();
    } else if (task.type === "normal") {
      await Deno.run({
        cmd: [join(__dirname, "play.sh"), ...params],
      }).status();
    }
  }
}

