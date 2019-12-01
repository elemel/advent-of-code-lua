local yulea = require("yulea")

local array = yulea.table.array
local elements = yulea.table.elements
local map = yulea.iterator.map
local range = yulea.iterator.range
local rep = yulea.iterator.rep

local function parsePoint(line)
  local x, y, dx, dy = line:match(
    "^position=<%s*(-?%d+), %s*(-?%d+)> velocity=<%s*(-?%d+), %s*(-?%d+)>$")

  return {tonumber(x), tonumber(y), tonumber(dx), tonumber(dy)}
end

local function bounds(points, time)
  local minX = math.huge
  local minY = math.huge

  local maxX = -math.huge
  local maxY = -math.huge

  for point in elements(points) do
    local x, y, dx, dy = table.unpack(point)

    minX = math.min(minX, x + dx * time)
    minY = math.min(minY, y + dy * time)

    maxX = math.max(x + dx * time, maxX)
    maxY = math.max(y + dy * time, maxY)
  end

  return minX, minY, maxX, maxY
end

local function area(points, time)
  local minX, minY, maxX, maxY = bounds(points, time)
  return (maxX - minX + 1) * (maxY - minY + 1)
end

local function printMessage(points, time)
  local minX, minY, maxX, maxY = bounds(points, time)
  local grid = {}

  for _ = 1, maxY - minY + 1 do
    table.insert(grid, array(rep(".", maxX - minX + 1)))
  end

  for point in elements(points) do
    local x, y, dx, dy = table.unpack(point)
    grid[y + dy * time - minY + 1][x + dx * time - minX + 1] = "#"
  end

  for row in elements(grid) do
    print(table.concat(row))
  end
end

local points = array(map(io.lines(), parsePoint))
local time = 0
local minArea = area(points, 0)
local nextArea = area(points, 1)

while nextArea < minArea do
  minArea = nextArea
  time = time + 1
  nextArea = area(points, time + 1)
end

printMessage(points, time)
