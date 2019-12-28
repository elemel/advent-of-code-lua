local intcode = require("intcode")

local source = io.read()
local program = intcode.Program.new(source)
program.inputQueue:push(2)
program:run()
print(program.outputQueue:pop())
