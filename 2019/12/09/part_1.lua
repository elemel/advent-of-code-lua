local midwint = require("midwint")

local source = io.read()
local program = midwint.Program.new(source)
program.inputs:push(1)
program:run()

while not program.outputs:isEmpty() do
  print(program.outputs:pop())
end
