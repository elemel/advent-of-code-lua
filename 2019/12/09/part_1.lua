local intcode = require("intcode")

local source = io.read()
local program = intcode.Program.new(source)
program.inputQueue:push(1)
program:run()

while not program.outputQueue:isEmpty() do
  print(program.outputQueue:pop())
end
