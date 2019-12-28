local intcode = require("intcode")
local yulea = require("yulea")

local function getLoopedCell(grid, x, y)
  local width = #grid[1]
  local height = #grid

  x = (x - 1) % width + 1
  y = (y - 1) % height + 1

  return grid[y][x]
end

local program = intcode.Program.new(io.read())
program:run()

local grid = {{}}

while not program.outputQueue:is_empty() do
  local output = program.outputQueue:pop_left()

  if output == 10 then
    table.insert(grid, {})
  else
    table.insert(grid[#grid], string.char(output))
  end
end

local totalAlignment = 0

for y, row in ipairs(grid) do
  for x, char in ipairs(row) do
    if (char == "#" and
      getLoopedCell(grid, x - 1, y) == "#" and
      getLoopedCell(grid, x + 1, y) == "#" and
      getLoopedCell(grid, x, y - 1) == "#" and
      getLoopedCell(grid, x, y + 1) == "#") then

      totalAlignment = totalAlignment + (x - 1) * (y - 1)
    end
  end
end

print(totalAlignment)
