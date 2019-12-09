local midwint = require("midwint")

local source = io.read()
local program = midwint.Program.new(source)
program.inputQueue:push(2)
program:run()
print(program.outputQueue:pop())
