local intcode = require("intcode")
local yulea = require("yulea")

local printGrid = yulea.printGrid

local function getLoopedCell(grid, x, y)
  local width = #grid[1]
  local height = #grid

  x = (x - 1) % width + 1
  y = (y - 1) % height + 1

  return grid[y][x]
end

local function printVideo(program)
  local result
  local grid = {{}}

  while program:canRead() do
    local output = program:read()

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

program:writeLine("A,A,B,C,B,C,B,C,C,A")
program:writeLine("L,10,R,8,R,8")
program:writeLine("L,10,L,12,R,8,R,10")
program:writeLine("R,10,L,12,R,10")
program:writeLine("n")

local result

repeat
  program:run()
  result = printVideo(program)
until program:isHalted()

print(result)
