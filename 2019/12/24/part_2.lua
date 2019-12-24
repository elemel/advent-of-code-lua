local yulea = require("yulea")

local enumerate = yulea.enumerate
local getCell = yulea.getCell
local join = yulea.join
local keys = yulea.keys
local map = yulea.map
local maxResult = yulea.maxResult
local minResult = yulea.minResult
local setCell = yulea.setCell
local split = yulea.split
local sum = yulea.sum
local unpack = unpack or table.unpack
local values = yulea.values

local directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

local function bugCount(grid)
  local result = 0

  for row in values(grid) do
    for char in values(row) do
      if char == "#" then
        result = result + 1
      end
    end
  end

  return result
end

local function newGrid()
  local result = {}

  for y = -2, 2 do
    for x = -2, 2 do
      setCell(result, x, y, ".")
    end
  end

  setCell(result, 0, 0, "?")
  return result
end

local function expandGrids(grids)
  local minZ = minResult(keys(grids))
  local maxZ = maxResult(keys(grids))

  if bugCount(grids[minZ]) >= 1 then
    grids[minZ - 1] = newGrid()
  end

  if bugCount(grids[maxZ]) >= 1 then
    grids[maxZ + 1] = newGrid()
  end
end

local function neighborCount(grids, x, y, z)
  local result = 0
  local grid = grids[z]

  for direction in values(directions) do
    local dx, dy = unpack(direction)
    local char = getCell(grid, x + dx, y + dy)

    if char == "#" then
      result = result + 1
    elseif char == nil then
      local belowGrid = grids[z - 1]

      if belowGrid and getCell(belowGrid, dx, dy) == "#" then
        result = result + 1
      end
    elseif char == "?" then
      local aboveGrid = grids[z + 1]

      if aboveGrid then
        for aboveY = -2, 2 do
          for aboveX = -2, 2 do
            if dx * aboveX + dy * aboveY == -2 then
              if getCell(aboveGrid, aboveX, aboveY) == "#" then
                result = result + 1
              end
            end
          end
        end
      end
    end
  end

  return result
end

local function liveAndDie(grids)
  local result = {}

  for z, grid in pairs(grids) do
    result[z] = {}

    for y, row in pairs(grid) do
      for x, char in pairs(row) do
        local count = neighborCount(grids, x, y, z)

        if char == "#" then
          if count ~= 1 then
            char = "."
          end
        elseif char == "." then
          if count == 1 or count == 2 then
            char = "#"
          end
        end

        setCell(result[z], x, y, char)
      end
    end
  end

  return result
end

local grid = {}

for y, line in enumerate(io.lines(), -2) do
  for x, char in enumerate(split(line), -2) do
    setCell(grid, x, y, char)
  end
end

setCell(grid, 0, 0, "?")
local grids = {}
grids[0] = grid

for minute = 1, 200 do
  expandGrids(grids)
  grids = liveAndDie(grids)
end

print(sum(map(values(grids), bugCount)))
