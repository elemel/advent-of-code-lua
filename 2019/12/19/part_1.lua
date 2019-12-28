local intcode = require("intcode")

local source = io.read()
local totalOutput = 0

for y = 0, 49 do
  for x = 0, 49 do
    local program = intcode.Program.new(source)

    program:write(x)
    program:write(y)

    program:run()
    totalOutput = totalOutput + program:read()
  end
end

print(totalOutput)
