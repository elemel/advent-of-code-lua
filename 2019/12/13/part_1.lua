local intcode = require("intcode")

local program = intcode.Program.new(io.read())
program:run()

local screen = {}

while program:hasOutput() do
  local x = program:read()
  local y = program:read()
  local id = program:read()

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
