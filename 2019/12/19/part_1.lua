local intcode = require("intcode")

local source = io.read()
local totalOutput = 0

for y = 0, 49 do
  for x = 0, 49 do
    local program = intcode.Program.new(source)

    program.inputQueue:push_right(x)
    program.inputQueue:push_right(y)

    program:run()

    local output = program.outputQueue:pop_left()
    totalOutput = totalOutput + output
  end
end

print(totalOutput)
