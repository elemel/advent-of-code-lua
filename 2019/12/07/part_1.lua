local intcode = require("intcode")
local yulea = require("yulea")

local elements = yulea.elements
local maxResult = yulea.maxResult
local permutations = yulea.permutations

local function signal(source, phases)
  local result = 0

  for phase in elements(phases) do
    local amplifier = intcode.compile(source)
    amplifier.inputs:push(phase)
    amplifier.inputs:push(result)
    intcode.run(amplifier)
    result = amplifier.outputs:pop()
  end

  return result
end

local source = io.read()

print(maxResult(
  permutations({4, 3, 2, 1, 0}):
  map(function(phases)
    return signal(source, phases)
  end)))
