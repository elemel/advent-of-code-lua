local intcode = require("intcode")

local program = intcode.compile(io.read())

program[1] = 12
program[2] = 2

intcode.run(program)
print(program[0])
