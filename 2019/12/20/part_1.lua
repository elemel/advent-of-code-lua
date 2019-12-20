local deque = require("deque")
local yulea = require("yulea")

local enumerate = yulea.enumerate
local getCell = yulea.getCell
local setCell = yulea.setCell
local split = yulea.split
local unpack = unpack or table.unpack

local directions = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}}

local function isAlpha(char)
  return string.match(char, "%a") ~= nil
end

local grid = {}

for y, line in enumerate(io.lines()) do
  for x, char in enumerate(split(line)) do
    setCell(grid, x, y, char)
  end
end

local labels = {}

for y, row in ipairs(grid) do
  for x, char in ipairs(row) do
    if isAlpha(char) then
      for _, direction in ipairs(directions) do
        local dx, dy = unpack(direction)

        if getCell(grid, x - dx, y - dy) == "." then
          local label

          if dx + dy < 0 then
            label = getCell(grid, x + dx, y + dy) .. char
          else
            label = char .. getCell(grid, x + dx, y + dy)
          end

          labels[label] = labels[label] or {}
          table.insert(labels[label], {x, y, dx, dy})
        end
      end
    end
  end
end

local portals = {}
local startX, startY

for label, positions in pairs(labels) do
  if label == "AA" then
    assert(#positions == 1)
    local x, y, dx, dy = unpack(positions[1])

    startX = x - dx
    startY = y - dy

    setCell(portals, x, y, "start")
  elseif label == "ZZ" then
    assert(#positions == 1)
    local x, y, _, _ = unpack(positions[1])
    setCell(portals, x, y, "end")
  else
    assert(#positions == 2)

    local x1, y1, dx1, dy1 = unpack(positions[1])
    local x2, y2, dx2, dy2 = unpack(positions[2])

    setCell(portals, x1, y1, {x2, y2, dx2, dy2})
    setCell(portals, x2, y2, {x1, y1, dx1, dy1})
  end
end

local queue = deque.new()
queue:push_right({startX, startY, 0})

local visited = {}

repeat
  local x, y, distance = unpack(queue:pop_left())

  for _, direction in ipairs(directions) do
    local dx, dy = unpack(direction)

    if not getCell(visited, x + dx, y + dy) then
      setCell(visited, x + dx, y + dy, true)

      local char = getCell(grid, x + dx, y + dy)

      if char == "." then
        queue:push_right({x + dx, y + dy, distance + 1})
      elseif isAlpha(char) then
        local portal2 = getCell(portals, x + dx, y + dy)

        if portal2 == "end" then
          print(distance)
          return
        end

        if portal2 ~= "start" then
          local x2, y2, dx2, dy2 = unpack(portal2)
          queue:push_right({x2 - dx2, y2 - dy2, distance + 1})
        end
      end
    end
  end
until queue:is_empty()
