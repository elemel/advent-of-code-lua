local yulea = require("yulea")

local enumerate = yulea.iterator.enumerate
local split = yulea.string.split

local function parseMove(s)
  local direction, steps = string.match(s, "(%a)(%d+)")
  return direction, tonumber(steps)
end

local function get2(t, x, y)
  return t[x] and t[x][y]
end

local function set2(t, x, y, v)
  t[x] = t[x] or {}
  t[x][y] = v
end

local directions = {
  D = {0, 1},
  L = {-1, 0},
  R = {1, 0},
  U = {0, -1},
}

local grid = {}
local minDistance = math.huge

for wire, path in enumerate(io.lines()) do
  local x = 0
  local y = 0

  for move in split(path, ",") do
    local direction, steps = parseMove(move)
    local dx, dy = table.unpack(directions[direction])

    for step = 1, steps do
      x = x + dx
      y = y + dy

      if wire == 1 then
        set2(grid, x, y, true)
      else
        if get2(grid, x, y) then
          minDistance = math.min(minDistance, math.abs(x) + math.abs(y))
        end
      end
    end
  end
end

print(minDistance)
