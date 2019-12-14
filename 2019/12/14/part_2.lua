local deque = require("deque")
local yulea = require("yulea")

local split = yulea.split
local toTuple = yulea.toTuple

local function parseQuantityChemical(s)
  local quantity, chemical = toTuple(split(s, " "))
  return tonumber(quantity), chemical
end

local function parseReaction(line)
  local inputsStr, outputStr = toTuple(split(line, " => "))
  local outputQuantity, outputChemical = parseQuantityChemical(outputStr)
  local inputs = {}

  for inputStr in split(inputsStr, ", ") do
    local inputQuantity, inputChemical = parseQuantityChemical(inputStr)
    inputs[inputChemical] = inputQuantity
  end

  return outputChemical, outputQuantity, inputs
end

local function oreDemand(fuelDemand, reactions)
  local supplies = {}
  local demands = {FUEL = fuelDemand}

  local demandQueue = deque.new()
  demandQueue:push_right("FUEL")

  repeat
    local demandChemical = demandQueue:pop_left()
    local demandQuantity = demands[demandChemical] or 0
    demands[demandChemical] = 0

    if demandQuantity <= (supplies[demandChemical] or 0) then
      supplies[demandChemical] =
        (supplies[demandChemical] or 0) - demandQuantity
    else
      demandQuantity = demandQuantity - (supplies[demandChemical] or 0)
      local outputQuantity, inputs = table.unpack(reactions[demandChemical])
      local reactionCount = math.ceil(demandQuantity / outputQuantity)
      supplies[demandChemical] = reactionCount * outputQuantity - demandQuantity

      for inputChemical, inputQuantity in pairs(inputs) do
        demands[inputChemical] =
          (demands[inputChemical] or 0) + reactionCount * inputQuantity

        if inputChemical ~= "ORE" then
          demandQueue:push_right(inputChemical)
        end
      end
    end
  until demandQueue:is_empty()

  return demands.ORE
end

local reactions = {}

for line in io.lines() do
  local outputChemical, outputQuantity, inputs = parseReaction(line)
  reactions[outputChemical] = {outputQuantity, inputs}
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
