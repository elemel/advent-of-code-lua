local intcode = require("intcode")

local program = intcode.Program.new(io.read())
program:write(5)
program:run()
print(program:read())
