local intcode = require("intcode")

local source = io.read()
local network = {}

for networkAddress = 0, 49 do
  network[networkAddress] = intcode.Program.new(source)
  network[networkAddress]:write(networkAddress)
end

local natX, natY
local lastNatY

while true do
  local idle = true

  for networkAddress = 0, 49 do
    if network[networkAddress]:isBlocked() then
      network[networkAddress]:write(-1)
    else
      idle = false
    end

    network[networkAddress]:run()

    if network[networkAddress]:hasOutput() then
      idle = false

      repeat
        local destinationAddress = network[networkAddress]:read()

        local x = network[networkAddress]:read()
        local y = network[networkAddress]:read()

        if destinationAddress == 255 then
          natX = x
          natY = y
        else
          network[destinationAddress]:write(x)
          network[destinationAddress]:write(y)
        end
      until not network[networkAddress]:hasOutput()
    end
  end

  if idle then
    assert(natY)

    if natY == lastNatY then
      print(natY)
      return
    end

    network[0]:write(natX)
    network[0]:write(natY)
    lastNatY = natY
  end
end
