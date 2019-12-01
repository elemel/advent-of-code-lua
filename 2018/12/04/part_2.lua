local yulea = require("yulea")

local array = yulea.table.array
local keys = yulea.table.keys
local values = yulea.table.values

local lines = array(io.lines())
table.sort(lines)

local guardId
local asleepSince
local guardMinutesAsleep = {}
local minutesAsleep

for _, line in ipairs(lines) do
  local minuteStr, observation =
    string.match(line, "^%[%d%d%d%d%-%d%d%-%d%d %d%d:(%d%d)] (.+)$")

  local minute = tonumber(minuteStr)

  if observation == "falls asleep" then
    asleepSince = minute
  elseif observation == "wakes up" then
    for i = asleepSince, minute - 1 do
      minutesAsleep[i] = (minutesAsleep[i] or 0) + 1
    end
  else
    guardId = tonumber(string.match(observation, "^Guard #(%d+) begins shift"))
    guardMinutesAsleep[guardId] = guardMinutesAsleep[guardId] or {}
    minutesAsleep = guardMinutesAsleep[guardId]
  end
end

local chosenGuardId
local chosenMinute
local maxCount = -math.huge

for guardId, minutesAsleep in pairs(guardMinutesAsleep) do
  for minute, count in pairs(minutesAsleep) do
    if count > maxCount then
      chosenGuardId = guardId
      chosenMinute = minute
      maxCount = count
    end
  end
end

print(chosenGuardId * chosenMinute)
