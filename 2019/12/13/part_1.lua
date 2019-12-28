local intcode = require("intcode")

local program = intcode.Program.new(io.read())
program:run()

local screen = {}

while not program.outputQueue:isEmpty() do
  local x = program.outputQueue:pop()
  local y = program.outputQueue:pop()
  local id = program.outputQueue:pop()

  screen[y] = screen[y] or {}
  screen[y][x] = id
end

local count = 0

for y, row in pairs(screen) do
  for x, tile in pairs(row) do
    if tile == 2 then
      count = count + 1
    end
  end
end

print(count)
