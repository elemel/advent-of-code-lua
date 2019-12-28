local intcode = require("intcode")

local source = io.read()
local network = {}

for networkAddress = 0, 49 do
  network[networkAddress] = intcode.Program.new(source)
  network[networkAddress].inputQueue:push(networkAddress)
end

local natX, natY
local lastNatY

while true do
  local idle = true

  for networkAddress = 0, 49 do
    if network[networkAddress]:isBlocked() then
      network[networkAddress].inputQueue:push(-1)
    else
      idle = false
    end

    network[networkAddress]:run()

    if not network[networkAddress].outputQueue:isEmpty() then
      idle = false

      while not network[networkAddress].outputQueue:isEmpty() do
        local destinationAddress = network[networkAddress].outputQueue:pop()

        local x = network[networkAddress].outputQueue:pop()
        local y = network[networkAddress].outputQueue:pop()

        if destinationAddress == 255 then
          natX = x
          natY = y
        else
          network[destinationAddress].inputQueue:push(x)
          network[destinationAddress].inputQueue:push(y)
        end
      end
    end
  end

  if idle then
    assert(natY)

    if natY == lastNatY then
      print(natY)
      return
    end

    network[0].inputQueue:push(natX)
    network[0].inputQueue:push(natY)
    lastNatY = natY
  end
end
