local midwint = require("midwint")
local yulea = require("yulea")

local split = yulea.split

local source = io.read()
local totalOutput = 0

for y = 0, 49 do
  for x = 0, 49 do
    local program = midwint.Program.new(source)

    program.inputQueue:push(x)
    program.inputQueue:push(y)

    program:run()

    local output = program.outputQueue:pop()
    totalOutput = totalOutput + output
  end
end

print(totalOutput)
