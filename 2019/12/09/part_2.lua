local midwint = require("midwint")

local source = io.read()
local program = midwint.Program.new(source)
program.inputs:push(2)
program:run()
print(program.outputs:pop())
