local midwint = require("midwint")

local program = midwint.Program.new(io.read())
program.inputs:push(1)
program:run()

while not program.outputs:isEmpty() do
  print(program.outputs:pop())
end
