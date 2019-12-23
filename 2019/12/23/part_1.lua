local midwint = require("midwint")

local source = io.read()
local network = {}

for networkAddress = 0, 49 do
  network[networkAddress] = midwint.Program.new(source)
  network[networkAddress].inputQueue:push(networkAddress)
end

while true do
  for networkAddress = 0, 49 do
    if network[networkAddress]:isBlocked() then
      network[networkAddress].inputQueue:push(-1)
    end

    network[networkAddress]:run()

    while not network[networkAddress].outputQueue:isEmpty() do
      local destinationAddress = network[networkAddress].outputQueue:pop()

      local x = network[networkAddress].outputQueue:pop()
      local y = network[networkAddress].outputQueue:pop()

      if destinationAddress == 255 then
        print(y)
        return
      end

      network[destinationAddress].inputQueue:push(x)
      network[destinationAddress].inputQueue:push(y)
    end
  end
end
