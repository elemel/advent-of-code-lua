local midwint = require("midwint")

local program = midwint.Program.new(io.read())
program.inputs:push(5)
program:run()
print(program.outputs:pop())
