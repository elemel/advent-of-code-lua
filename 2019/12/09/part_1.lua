local intcode = require("intcode")

local source = io.read()
local program = intcode.Program.new(source)
program.inputQueue:push_right(1)
program:run()

while not program.outputQueue:is_empty() do
  print(program.outputQueue:pop_left())
end
