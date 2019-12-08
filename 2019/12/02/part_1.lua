local midwint = require("midwint")

local program = midwint.Program.new(io.read())

program[1] = 12
program[2] = 2

program:run()
print(program[0])
