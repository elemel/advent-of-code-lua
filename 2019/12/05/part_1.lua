local intcode = require("intcode")

local program = intcode.Program.new(io.read())
program.inputQueue:push(1)
program:run()

while not program.outputQueue:isEmpty() do
  print(program.outputQueue:pop())
end
