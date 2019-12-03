local yulea = require("yulea")

local function powerLevel(x, y, serialNumber)
  local rackId = x + 10
  local result = rackId * y
  result = result + serialNumber
  result = result * rackId
  result = math.floor(result / 100) % 10
  return result - 5
end

local function totalPower(x, y, serialNumber)
  local result = 0

  for x2 = x, x + 2 do
    for y2 = y, y + 2 do
      result = result + powerLevel(x2, y2, serialNumber)
    end
  end

  return result
end

local serialNumber = tonumber(io.read())
local largestTotalPower = -math.huge
local chosenX, chosenY

for x = 1, 300 - 2 do
  for y = 1, 300 - 2 do
    local power = totalPower(x, y, serialNumber)

    if power > largestTotalPower then
      largestTotalPower = power
      chosenX = x
      chosenY = y
    end
  end
end

print(chosenX .. "," .. chosenY)
