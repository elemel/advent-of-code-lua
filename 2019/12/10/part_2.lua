local yulea = require("yulea")

local enumerate = yulea.enumerate
local gcd = yulea.gcd
local split = yulea.split

local x = 31
local y = 20

local grid = {}

for y2, line in enumerate(io.lines(), 0) do
  grid[y2] = {}

  for x2, char in enumerate(split(line), 0) do
    grid[y2][x2] = char

    if char == "X" then
      x = x2
      y = y2
    end
  end
end

local minX = 0
local minY = 0

local maxX = #grid[0]
local maxY = #grid

local groups = {}

for y2 = minY, maxY do
  for x2 = minX, maxX do
    if (x2 ~= x or y2 ~= y) and grid[y2][x2] ~= "." then
      local dx = x2 - x
      local dy = y2 - y

      local d = gcd(dx, dy)

      dx = dx / d
      dy = dy / d

      groups[dy] = groups[dy] or {}
      groups[dy][dx] = groups[dy][dx] or {}
      table.insert(groups[dy][dx], {x2, y2})
    end
  end
end

function distance(position)
  local x2, y2 = table.unpack(position)
  return (x2 - x) * (y2 - y)
end

local sortedGroups = {}

for dy, row in pairs(groups) do
  for dx, positions in pairs(row) do
    table.sort(positions, function(a, b)
      return distance(a) < distance(b)
    end)

    table.insert(sortedGroups, {{dx, dy}, positions})
  end
end

function angle(directionPositions)
  local direction, _ = table.unpack(directionPositions)
  local dx, dy = table.unpack(direction)
  return math.atan2(dx, -dy) % (2 * math.pi)
end

table.sort(sortedGroups, function(a, b)
  return angle(a) < angle(b)
end)

local j = 1
local x2, y2

for i = 1, 200 do
  local directionPositions = sortedGroups[j]
  local direction, positions = table.unpack(directionPositions)
  x2, y2 = table.unpack(table.remove(positions))

  if #positions == 0 then
    table.remove(sortedGroups, j)

    if #sortedGroups == 0 then
      break
    end
  else
    j = j + 1
  end

  j = (j - 1) % #sortedGroups + 1
end

print(100 * x2 + y2)
