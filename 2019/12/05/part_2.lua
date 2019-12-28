local intcode = require("intcode")

local program = intcode.Program.new(io.read())
program.inputQueue:push(5)
program:run()
print(program.outputQueue:pop())
