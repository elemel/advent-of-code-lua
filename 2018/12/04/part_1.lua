local yulea = require("yulea")

local array = yulea.table.array
local keys = yulea.table.keys
local reduce = yulea.iterator.reduce
local sum = yulea.math.sum
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

local guardsAsleep = {}

for k, v in pairs(guardMinutesAsleep) do
  guardsAsleep[k] = sum(values(v))
end

local chosenGuardId = reduce(keys(guardsAsleep), function(a, b)
  return guardsAsleep[a] < guardsAsleep[b] and b or a
end)

minutesAsleep = guardMinutesAsleep[chosenGuardId]

local chosenMinute = reduce(keys(minutesAsleep), function(a, b)
  return minutesAsleep[a] < minutesAsleep[b] and b or a
end)

print(chosenGuardId * chosenMinute)
