local intcode = require("intcode")

local program = intcode.compile(io.read())
program.inputs:push(5)
intcode.run(program)
print(program.outputs:pop())
