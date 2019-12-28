local intcode = require("intcode")

local program = intcode.Program.new(io.read())
program.inputQueue:push_right(1)
program:run()

while not program.outputQueue:is_empty() do
  print(program.outputQueue:pop_left())
end
