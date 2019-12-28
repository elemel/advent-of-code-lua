local intcode = require("intcode")

local source = io.read()
local program = intcode.Program.new(source)
program:write(2)
program:run()
print(program:read())
