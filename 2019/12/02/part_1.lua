local intcode = require("intcode")

local program = intcode.Program.new(io.read())

program.memory[1] = 12
program.memory[2] = 2

program:run()
print(program.memory[0])
