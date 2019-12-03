local yulea = require("yulea")

local function powerLevel(x, y, serialNumber)
  local rackId = x + 10
  local result = rackId * y
  result = result + serialNumber
  result = result * rackId
  result = math.floor(result / 100) % 10
  return result - 5
end

local serialNumber = tonumber(io.read())
local powerLevels = {}

for x = 1, 300 do
  powerLevels[x] = {}

  for y = 1, 300 do
    powerLevels[x][y] = powerLevel(x, y, serialNumber)
  end
end

local largestTotalPower = -math.huge
local chosenX, chosenY, chosenSize

for size = 1, 300 do
  io.stderr:write("size = " .. size .. "\n")
  local power

  for x = 1, 300 - size + 1 do
    for y = 1, 300 - size + 1 do
      if y == 1 then
        power = 0

        for x2 = x, x + size - 1 do
          for y2 = y, y + size - 1 do
            power = power + powerLevels[x2][y2]
          end
        end
      else
        for x2 = x, x + size  - 1 do
          power = power - powerLevels[x2][y - 1]
          power = power + powerLevels[x2][y + size - 1]
        end
      end

      if power > largestTotalPower then
        largestTotalPower = power

        chosenX = x
        chosenY = y
        chosenSize = size
      end
    end
  end
end

print(chosenX .. "," .. chosenY .. "," .. chosenSize)
