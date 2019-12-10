local yulea = require("yulea")

local enumerate = yulea.enumerate
local gcd = yulea.gcd
local split = yulea.split
local squaredDistance2 = yulea.squaredDistance2

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

local sortedGroups = {}

for dy, row in pairs(groups) do
  for dx, positions in pairs(row) do
    table.sort(positions, function(a, b)
      return (squaredDistance2(x, y, table.unpack(a)) >
        squaredDistance2(x, y, table.unpack(b)))
    end)

    table.insert(sortedGroups, {{dx, dy}, positions})
  end
end

function rankDirection(x, y)
  if x < 0 then
    if y < 0 then
      -- Southwest
      return 5, -y, -x
    elseif 0 < y then
      -- Northwest
      return 3, -x, y
    else
      -- West
      return 4, 0, -x
    end
  elseif 0 < x then
    if y < 0 then
      -- Southeast
      return 7, x, -y
    elseif 0 < y then
      -- Northeast
      return 1, y, x
    else
      -- East
      return 0, 0, x
    end
  else
    if y < 0 then
      -- South
      return 6, 0, -y
    elseif 0 < y then
      -- North
      return 2, 0, y
    else
      error("Zero direction")
    end
  end
end

function compareDirections(x1, y1, x2, y2)
  local a1, b1, c1 = rankDirection(x1, y1)
  local a2, b2, c2 = rankDirection(x2, y2)

  if a1 ~= a2 then
    return a1 < a2
  end

  return b1 * c2 < b2 * c1
end

table.sort(sortedGroups, function(directionPositions1, directionPositions2)
  local direction1, _ = table.unpack(directionPositions1)
  local direction2, _ = table.unpack(directionPositions2)

  local dx1, dy1 = table.unpack(direction1)
  local dx2, dy2 = table.unpack(direction2)

  return compareDirections(-dy1, dx1, -dy2, dx2)
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
