local yulea = require("yulea")

local array = yulea.table.array
local bind = yulea.functional.bind
local elements = yulea.table.elements
local index = yulea.functional.index
local keys = yulea.table.keys
local map = yulea.iterator.map
local maxResult = yulea.math.maxResult
local minResult = yulea.math.minResult
local values = yulea.table.values

local function parseCoordinate(line)
  local x, y = string.match(line, "(%d+), (%d+)")
  return {tonumber(x), tonumber(y)}
end

local function manhattanDistance(x1, y1, x2, y2)
  return math.abs(x2 - x1) + math.abs(y2 - y1)
end

local function closest(coordinates, x, y)
  local minDistance = math.huge
  local result

  for i, coordinate in ipairs(coordinates) do
    local distance = manhattanDistance(x, y, table.unpack(coordinate))

    if distance == minDistance then
      result = nil
    elseif distance < minDistance then
      result = i
      minDistance = distance
    end
  end

  return result
end

local coordinates = array(map(io.lines(), parseCoordinate))

local minX = minResult(map(elements(coordinates), bind(index, nil, 1)))
local minY = minResult(map(elements(coordinates), bind(index, nil, 2)))

local maxX = maxResult(map(elements(coordinates), bind(index, nil, 1)))
local maxY = maxResult(map(elements(coordinates), bind(index, nil, 2)))

local sizes = {}
local infinite = {}

for x = minX, maxX do
  for y = minY, maxY do
    local i = closest(coordinates, x, y)

    if i then
      sizes[i] = (sizes[i] or 0) + 1

      if x == minX or y == minY or x == maxX or y == maxY then
        infinite[i] = true
      end
    end
  end
end

for i in keys(infinite) do
  sizes[i] = nil
end

print(maxResult(values(sizes)))
