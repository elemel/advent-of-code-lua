local intcode = require("intcode")

local source = io.read()
local network = {}

for networkAddress = 0, 49 do
  network[networkAddress] = intcode.Program.new(source)
  network[networkAddress].inputQueue:push_right(networkAddress)
end

while true do
  for networkAddress = 0, 49 do
    if network[networkAddress]:isBlocked() then
      network[networkAddress].inputQueue:push_right(-1)
    end

    network[networkAddress]:run()

    while not network[networkAddress].outputQueue:is_empty() do
      local destinationAddress = network[networkAddress].outputQueue:pop_left()

      local x = network[networkAddress].outputQueue:pop_left()
      local y = network[networkAddress].outputQueue:pop_left()

      if destinationAddress == 255 then
        print(y)
        return
      end

      network[destinationAddress].inputQueue:push_right(x)
      network[destinationAddress].inputQueue:push_right(y)
    end
  end
end