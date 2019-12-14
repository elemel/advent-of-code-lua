local deque = require("deque")
local yulea = require("yulea")

local array = yulea.array
local elements = yulea.elements
local map = yulea.map
local split = yulea.split

local function parseChemical(s)
  local quantity, name = table.unpack(array(split(s, " ")))
  return {tonumber(quantity), name}
end

local function parseReaction(line)
  local input, output = table.unpack(array(split(line, " => ")))
  local inputs = array(map(split(input, ", "), parseChemical))
  return inputs, parseChemical(output)
end

local function oreDemand(fuelDemand, reactions)
  local supplies = {}
  local demands = {FUEL = fuelDemand}

  local queue = deque.new()
  queue:push_right("FUEL")

  repeat
    local chemical = queue:pop_left()
    local quantity = demands[chemical] or 0
    demands[chemical] = 0

    if quantity <= (supplies[chemical] or 0) then
      supplies[chemical] = (supplies[chemical] or 0) - quantity
    else
      quantity = quantity - (supplies[chemical] or 0)
      local outputQuantity, inputs = table.unpack(reactions[chemical])
      local count = math.ceil(quantity / outputQuantity)
      supplies[chemical] = count * outputQuantity - quantity

      for input in elements(inputs) do
        local inputQuantity, inputChemical = table.unpack(input)

        demands[inputChemical] =
          (demands[inputChemical] or 0) + count * inputQuantity

        if inputChemical ~= "ORE" then
          queue:push_right(inputChemical)
        end
      end
    end
  until queue:is_empty()

  return demands.ORE
end

local reactions = {}

for line in io.lines() do
  local inputs, output = parseReaction(line)
  local quantity, chemical = table.unpack(output)
  reactions[chemical] = {quantity, inputs}
end

local oreSupply = 1000000000000

local minFuel = 0
local maxFuel = 1

while oreDemand(maxFuel, reactions) < oreSupply do
  minFuel = maxFuel
  maxFuel = 2 * maxFuel
end

while maxFuel - minFuel > 2 do
  local middleFuel = math.floor((minFuel + maxFuel) / 2)

  if oreDemand(middleFuel, reactions) < oreSupply then
    minFuel = middleFuel
  else
    maxFuel = middleFuel
  end
end

print(minFuel)
