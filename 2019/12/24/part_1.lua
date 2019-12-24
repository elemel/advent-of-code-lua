local yulea = require("yulea")

local elements = yulea.elements
local enumerate = yulea.enumerate
local getCell = yulea.getCell
local join = yulea.join
local map = yulea.map
local setCell = yulea.setCell
local split = yulea.split
local unpack = unpack or table.unpack
local values = yulea.values

local directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

local function biodiversityRating(grid)
  local result = 0
  local points = 1

  for y, row in ipairs(grid) do
    for x, char in ipairs(row) do
      if char == "#" then
        result = result + points
      end

      points = 2 * points
    end
  end

  return result
end

local function liveAndDie(grid)
  local result = {}

  for y, row in ipairs(grid) do
    for x, char in ipairs(row) do
      local count = 0

      for direction in values(directions) do
        local dx, dy = unpack(direction)

        if getCell(grid, x + dx, y + dy) == "#" then
          count = count + 1
        end
      end

      if char == "#" then
        if count ~= 1 then
          char = "."
        end
      else
        if count == 1 or count == 2 then
          char = "#"
        end
      end

      setCell(result, x, y, char)
    end
  end

  return result
end

local function key(grid)
  return join(map(elements(grid), table.concat))
end

local grid = {}

for y, line in enumerate(io.lines()) do
  for x, char in enumerate(split(line)) do
    setCell(grid, x, y, char)
  end
end

local seen = {}
seen[key(grid)] = true

while true do
  grid = liveAndDie(grid)
  local k = key(grid)

  if seen[k] then
    break
  end

  seen[k] = true
end

print(biodiversityRating(grid))
