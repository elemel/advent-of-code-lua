local yulea = require("yulea")

local enumerateTuple = yulea.iterator.enumerateTuple
local split = yulea.string.split

local directions = {
  D = {0, 1},
  L = {-1, 0},
  R = {1, 0},
  U = {0, -1},
}

local function parseRay(s)
  local direction, length = string.match(s, "(%a)(%d+)")
  local dx, dy = table.unpack(directions[direction])
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

for step, x, y in enumerateTuple(traceWire(io.read())) do
  grid[x] = grid[x] or {}
  grid[x][y] = step
end

local minSteps = math.huge

for step, x, y in enumerateTuple(traceWire(io.read())) do
  if grid[x] and grid[x][y] then
    minSteps = math.min(minSteps, step + grid[x][y])
  end
end

print(minSteps)
