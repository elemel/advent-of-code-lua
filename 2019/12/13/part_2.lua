local intcode = require("intcode")

local function printScreen(screen)
  local tiles = {"#", "%", "=", "O"}

  for y = 0, #screen do
    local line = {}

    for x = 0, #screen[y] do
      local tile = screen[y][x]
      line[#line + 1] = tiles[tile] or " "
    end

    print(table.concat(line))
  end
end

local program = intcode.Program.new(io.read())
program.memory[0] = 2

local input = 0
local screen = {}
local score = 0

repeat
  program:write(input)
  program:run()

  local paddleX
  local ballX

  while program:canRead() do
    local x = program:read()
    local y = program:read()
    local id = program:read()

    if x == -1 and y == 0 then
      score = id
    else
      screen[y] = screen[y] or {}
      screen[y][x] = id

      if id == 3 then
        paddleX = x
      end

      if id == 4 then
        ballX = x
      end
    end
  end

  -- printScreen(screen)

  input = 0

  if paddleX and ballX then
    if paddleX < ballX then
      input = 1
    elseif paddleX > ballX then
      input = -1
    end
  end
until program:isHalted()

print(score)
