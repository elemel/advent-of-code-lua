local midwint = require("midwint")
local yulea = require("yulea")

local split = yulea.split

local function containsPoint(source, x, y)
  local program = midwint.Program.new(source)

  program.inputQueue:push(x)
  program.inputQueue:push(y)

  program:run()

  return program.outputQueue:pop() ~= 0
end

local source = io.read()
local x = 0

for y = 99, math.huge do
  while not containsPoint(source, x, y) do
    x = x + 1
  end

  if containsPoint(source, x + 99, y - 99) then
    print(10000 * x + y - 99)
    break
  end
end
