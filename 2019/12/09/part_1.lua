local midwint = require("midwint")

local source = io.read()
local program = midwint.Program.new(source)
program.inputQueue:push(1)
program:run()

while not program.outputQueue:isEmpty() do
  print(program.outputQueue:pop())
end
