local intcode = require("intcode")

local source = io.read()
local program = intcode.Program.new(source)
program.inputQueue:push_right(2)
program:run()
print(program.outputQueue:pop_left())
