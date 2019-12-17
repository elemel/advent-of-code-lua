local yulea = require("yulea")

local leastCommonMultiple =
  yulea.leastCommonMultiple64 or yulea.leastCommonMultiple

local map = yulea.map
local range = yulea.range

local function parseVector(line)
  local x, y, z = string.match(line, "<x=(-?%d+), y=(-?%d+), z=(-?%d+)>")
  return tonumber(x), tonumber(y), tonumber(z)
end

local function applyGravity(positions, velocities)
  for i = 1, #positions - 1 do
    for j = i + 1, #positions do
      if positions[i] < positions[j] then
        velocities[i] = velocities[i] + 1
        velocities[j] = velocities[j] - 1
      elseif positions[i] > positions[j] then
        velocities[i] = velocities[i] - 1
        velocities[j] = velocities[j] + 1
      end
    end
  end
end

local function applyVelocity(positions, velocities)
  for i = 1, #positions do
    positions[i] = positions[i] + velocities[i]
  end
end

local function period(positions, velocities)
  local seen = {}

  for step = 0, math.huge do
    local k = (table.concat(positions, " ") .. " " ..
      table.concat(velocities, " "))

    if seen[k] then
      return step
    end

    seen[k] = true

    applyGravity(positions, velocities)
    applyVelocity(positions, velocities)
  end
end

local positionColumns = {{}, {}, {}}
local velocityColumns = {{}, {}, {}}

for line in io.lines() do
  for axis, value in ipairs({parseVector(line)}) do
    table.insert(positionColumns[axis], value)
    table.insert(velocityColumns[axis], 0)
  end
end

local result = leastCommonMultiple(map(
  range(1, 3),
  function(axis)
    return period(positionColumns[axis], velocityColumns[axis])
  end))

result = string.gsub(tostring(result), "L", "")
print(result)
