local deque = require("deque")
local yulea = require("yulea")

local elements = yulea.elements
local keys = yulea.keys
local reverse = yulea.reverse
local split = yulea.split
local toArray = yulea.toArray
local topologicalSort = yulea.topologicalSort
local toSet = yulea.toSet
local toTuple = yulea.toTuple
local unpack = unpack or table.unpack

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

local reactions = {}
local dependencies = {}

for line in io.lines() do
  local outputChemical, outputQuantity, inputs = parseReaction(line)
  reactions[outputChemical] = {outputQuantity, inputs}
  dependencies[outputChemical] = {}

  for inputChemical in pairs(inputs) do
    dependencies[outputChemical][inputChemical] = true
  end
end

local sortedChemicals = topologicalSort(dependencies)
reverse(sortedChemicals)

local balances = {FUEL = -1}

for chemical in elements(sortedChemicals) do
  local quantity = balances[chemical] or 0

  if quantity < 0 then
    local outputQuantity, inputs = unpack(reactions[chemical])
    local reactionCount = math.ceil(-quantity / outputQuantity)
    balances[chemical] = balances[chemical] + reactionCount * outputQuantity

    for inputChemical, inputQuantity in pairs(inputs) do
      balances[inputChemical] =
        (balances[inputChemical] or 0) - reactionCount * inputQuantity
    end
  end
end

print(-balances.ORE)
