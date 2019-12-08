local intcode = require("intcode")

local program = intcode.compile(io.read())
program.inputs:push(1)
intcode.run(program)

while not program.outputs:isEmpty() do
  print(program.outputs:pop())
end
