local midwint = require("midwint")

local program = midwint.Program.new(io.read())
program.inputQueue:push(5)
program:run()
print(program.outputQueue:pop())
