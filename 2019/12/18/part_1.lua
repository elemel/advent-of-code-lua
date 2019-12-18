local deque = require("deque")
local yulea = require("yulea")

local enumerate = yulea.enumerate
local getCell = yulea.getCell
local printGrid = yulea.printGrid
local setCell = yulea.setCell
local split = yulea.split
local toArray = yulea.toArray
local unpack = unpack or table.unpack

local function isKey(char)
  return char ~= string.upper(char)
end

local function isDoor(char)
  return char ~= string.lower(char)
end

local function hasKey(char, keys)
  return string.match(keys, char)
end

local function addKey(char, keys)
  local t = toArray(split(keys))
  t[#t + 1] = char
  table.sort(t)
  return table.concat(t)
end

local directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

local grid = {}
local entranceX, entranceY
local allKeys = ""

for y, line in enumerate(io.lines()) do
  for x, char in enumerate(split(line)) do
    if char == "@" then
      entranceX = x
      entranceY = y

      char = "."
    elseif isKey(char) then
      allKeys = addKey(char, allKeys)
    end

    setCell(grid, x, y, char)
  end
end

local queue = deque.new()
queue:push_right({0, entranceX, entranceY, ""})
local distances = {}
local goalDistance = math.huge

repeat
  local step, x, y, keys = unpack(queue:pop_left())

  if keys == allKeys then
    goalDistance = math.min(goalDistance, step)
  else
    local state = table.concat({x, y, keys}, " ")

    if step < (distances[state] or math.huge) then
      distances[state] = step

      for _, direction in ipairs(directions) do
        local dx, dy = unpack(direction)
        local char = getCell(grid, x + dx, y + dy)

        if char == "." then
          queue:push_right({step + 1, x + dx, y + dy, keys})
        elseif char ~= "#" then
          if isKey(char) then
            if hasKey(char, keys) then
              queue:push_right({step + 1, x + dx, y + dy, keys})
            else
              queue:push_right({step + 1, x + dx, y + dy, addKey(char, keys)})
            end
          elseif isDoor(char) and hasKey(string.lower(char), keys) then
            queue:push_right({step + 1, x + dx, y + dy, keys})
          end
        end
      end
    end
  end
until queue:is_empty()

print(goalDistance)
