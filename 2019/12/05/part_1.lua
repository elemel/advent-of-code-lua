local intcode = require("intcode")

local program = intcode.Program.new(io.read())
program:write(1)
program:run()

while program:hasOutput() do
  print(program:read())
end
