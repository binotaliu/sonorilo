import { parse } from "https://deno.land/std@0.112.0/encoding/yaml.ts";
import { dirname, fromFileUrl, join } from "https://deno.land/std@0.112.0/path/mod.ts";

const __dirname = dirname(fromFileUrl(import.meta.url));

const yamlFilePath = join(__dirname, "schedule.yaml");

async function checkAndPlaySound() {
  const yamlContent = await Deno.readTextFile(yamlFilePath);
  const schedules = parse(yamlContent);

  const now = new Date();
  const currentHour = now.getHours();
  const currentMinute = now.getMinutes();

  for (const task of schedules) {
    const [hour, minute] = task.time.split(":").map(Number);

    if (hour === currentHour && minute === currentMinute) {
      const soundFilePath = join(__dirname, "sounds", task.sound);

      const soundVolume = task.volume?.toString();

      const params = [soundFilePath, soundVolume].filter((i) => i).map(String);

      await Deno.run({
        cmd: [join(__dirname, "play.sh"), ...params],
      }).status();
    }
  }
}

function startPreciseInterval() {
  const now = new Date();
  const millisecondsUntilNextMinute =
    (60 - now.getSeconds()) * 1000 - now.getMilliseconds();

  setTimeout(() => {
    setInterval(() => {
      checkAndPlaySound().catch((err) =>
        console.error("Error executing task:", err)
      );
    }, 60 * 1000);

    checkAndPlaySound().catch((err) =>
      console.error("Error executing task:", err)
    );
  }, millisecondsUntilNextMinute);

  console.log(
    `Daemon started. First check will run in ${millisecondsUntilNextMinute} ms.`
  );
}

startPreciseInterval();

