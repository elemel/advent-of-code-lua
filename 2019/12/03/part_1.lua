local yulea = require("yulea")

local split = yulea.string.split
local unpack = unpack or table.unpack

local directions = {
  D = {0, 1},
  L = {-1, 0},
  R = {1, 0},
  U = {0, -1},
}

local function parseRay(s)
  local direction, length = string.match(s, "(%a)(%d+)")
  local dx, dy = unpack(directions[direction])
  return dx, dy, tonumber(length)
end

local function traceWire(path)
  return coroutine.wrap(function()
    local x = 0
    local y = 0

    for ray in split(path, ",") do
      local dx, dy, length = parseRay(ray)

      for _ = 1, length do
        x = x + dx
        y = y + dy

        coroutine.yield(x, y)
      end
    end
  end)
end

local grid = {}

for x, y in traceWire(io.read()) do
  grid[x] = grid[x] or {}
  grid[x][y] = true
end

local minDistance = math.huge

for x, y in traceWire(io.read()) do
  if grid[x] and grid[x][y] then
    minDistance = math.min(minDistance, math.abs(x) + math.abs(y))
  end
end

print(minDistance)
