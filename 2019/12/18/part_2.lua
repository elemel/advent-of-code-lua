local bit32 = bit32 or bit
local deque = require("deque")
local heap = require("binary_heap")
local yulea = require("yulea")

local band = bit32.band
local bor = bit32.bor
local enumerate = yulea.enumerate
local getCell = yulea.getCell
local lshift = bit32.lshift
local setCell = yulea.setCell
local split = yulea.split
local unpack = unpack or table.unpack

local function isKey(char)
  return char ~= string.upper(char)
end

local function isDoor(char)
  return char ~= string.lower(char)
end

local function toBit(char)
  return string.byte(string.lower(char)) - string.byte("a")
end

local function addKey(mask, char)
  return bor(mask, lshift(1, toBit(char)))
end

local function containsKey(mask, char)
  return band(mask, lshift(1, toBit(char))) ~= 0
end

local directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
local quadrants = {{1, 1}, {-1, 1}, {-1, -1}, {1, -1}}

local grid = {}
local positions = {}
local allKeyMask = 0

for y, line in enumerate(io.lines()) do
  for x, char in enumerate(split(line)) do
    if char == "@" or isKey(char) or isDoor(char) then
      positions[char] = {x, y}

      if isKey(char) then
        allKeyMask = addKey(allKeyMask, char)
      end
    end

    setCell(grid, x, y, char)
  end
end

local entranceX, entranceY = unpack(positions["@"])
positions["@"] = nil

setCell(grid, entranceX, entranceY, "#")

for _, direction in ipairs(directions) do
  local dx, dy = unpack(direction)
  setCell(grid, entranceX + dx, entranceY + dy, "#")
end

for i, offset in ipairs(quadrants) do
  local dx, dy = unpack(offset)
  setCell(grid, entranceX + dx, entranceY + dy, tostring(i))
  positions[tostring(i)] = {entranceX + dx, entranceY + dy}
end

local graph = {}

for source, position in pairs(positions) do
  local x, y = unpack(position)

  local queue = deque.new()
  queue:push_right({x, y, 0})

  local visited = {}
  setCell(visited, x, y, true)

  repeat
    local x, y, distance = unpack(queue:pop_left())

    for _, direction in ipairs(directions) do
      local dx, dy = unpack(direction)

      if not getCell(visited, x + dx, y + dy) then
        setCell(visited, x + dx, y + dy, true)
        local target = getCell(grid, x + dx, y + dy)

        if positions[target] then
          graph[source] = graph[source] or {}
          graph[source][target] = distance + 1
        elseif target == "." then
          queue:push_right({x + dx, y + dy, distance + 1})
        end
      end
    end
  until queue:is_empty()
end

local queue = heap:new()
queue:insert(0, {"1", "2", "3", "4", 0})

local visited = {}

repeat
  local totalDistance, state = queue:pop()
  local stateStr = table.concat(state, " ")

  if not visited[stateStr] then
    visited[stateStr] = true
    local keyMask = table.remove(state)

    if keyMask == allKeyMask then
      print(totalDistance)
      return
    end

    for i, source in ipairs(state) do
      for target, distance in pairs(graph[source]) do
        if isKey(target) then
          local newState = {unpack(state)}
          newState[i] = target
          table.insert(newState, addKey(keyMask, target))

          queue:insert(totalDistance + distance, newState)
        elseif isDoor(target) then
          if containsKey(keyMask, target) then
            local newState = {unpack(state)}
            newState[i] = target
            table.insert(newState, keyMask)

            queue:insert(totalDistance + distance, newState)
          end
        end
      end
    end
  end
until queue:empty()
