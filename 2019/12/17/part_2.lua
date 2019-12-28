local intcode = require("intcode")
local yulea = require("yulea")

local printGrid = yulea.printGrid
local split = yulea.split

local function getLoopedCell(grid, x, y)
  local width = #grid[1]
  local height = #grid

  x = (x - 1) % width + 1
  y = (y - 1) % height + 1

  return grid[y][x]
end

local function writeLine(program, line)
  for char in split(line) do
    program.inputQueue:push_right(string.byte(char))
  end

  program.inputQueue:push_right(10)
end

local function printVideo(program)
  local result
  local grid = {{}}

  while not program.outputQueue:is_empty() do
    local output = program.outputQueue:pop_left()

    if output >= 256 then
      result = output
      break
    end

    if output == 10 then
      table.insert(grid, {})
    else
      table.insert(grid[#grid], string.char(output))
    end
  end

  -- printGrid(grid)
  return result
end

local program = intcode.Program.new(io.read())
program.memory[0] = 2
writeLine(program, "A,A,B,C,B,C,B,C,C,A")
writeLine(program, "L,10,R,8,R,8")
writeLine(program, "L,10,L,12,R,8,R,10")
writeLine(program, "R,10,L,12,R,10")
-- writeLine(program, "y")
writeLine(program, "n")

local result

repeat
  program:run()
  result = printVideo(program)
until program:isHalted()

print(result)
