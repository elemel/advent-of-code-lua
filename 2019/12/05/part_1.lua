local intcode = require("intcode")

local program = intcode.Program.new(io.read())
program:write(1)
program:run()

while not program.outputQueue:is_empty() do
  print(program:read())
end
