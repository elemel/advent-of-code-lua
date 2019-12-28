local intcode = require("intcode")

local source = io.read()
local network = {}

for networkAddress = 0, 49 do
  network[networkAddress] = intcode.Program.new(source)
  network[networkAddress].inputQueue:push_right(networkAddress)
end

local natX, natY
local lastNatY

while true do
  local idle = true

  for networkAddress = 0, 49 do
    if network[networkAddress]:isBlocked() then
      network[networkAddress].inputQueue:push_right(-1)
    else
      idle = false
    end

    network[networkAddress]:run()

    if not network[networkAddress].outputQueue:is_empty() then
      idle = false

      while not network[networkAddress].outputQueue:is_empty() do
        local destinationAddress =
          network[networkAddress].outputQueue:pop_left()

        local x = network[networkAddress].outputQueue:pop_left()
        local y = network[networkAddress].outputQueue:pop_left()

        if destinationAddress == 255 then
          natX = x
          natY = y
        else
          network[destinationAddress].inputQueue:push_right(x)
          network[destinationAddress].inputQueue:push_right(y)
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

    network[0].inputQueue:push_right(natX)
    network[0].inputQueue:push_right(natY)
    lastNatY = natY
  end
end
