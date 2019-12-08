local intcode = require("intcode")

local program = intcode.compile(io.read())
program.inputs:push_right(1)
intcode.run(program)

while not program.outputs:is_empty() do
  print(program.outputs:pop_left())
end
