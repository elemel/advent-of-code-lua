local intcode = require("intcode")

local source = io.read()
local network = {}

for networkAddress = 0, 49 do
  network[networkAddress] = intcode.Program.new(source)
  network[networkAddress]:write(networkAddress)
end

while true do
  for networkAddress = 0, 49 do
    if network[networkAddress]:isBlocked() then
      network[networkAddress]:write(-1)
    end

    network[networkAddress]:run()

    while not network[networkAddress].outputQueue:is_empty() do
      local destinationAddress = network[networkAddress]:read()

      local x = network[networkAddress]:read()
      local y = network[networkAddress]:read()

      if destinationAddress == 255 then
        print(y)
        return
      end

      network[destinationAddress]:write(x)
      network[destinationAddress]:write(y)
    end
  end
end
