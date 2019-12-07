local intcode = require("intcode")
local yulea = require("yulea")

local elements = yulea.elements
local maxResult = yulea.maxResult
local permutations = yulea.permutations

local source = io.read()

local function signal(phases)
  local result = 0

  for phase in elements(phases) do
    local amplifier = intcode.compile(source)
    amplifier.inputs:push_right(phase)
    amplifier.inputs:push_right(result)
    intcode.run(amplifier)
    result = amplifier.outputs:pop_left()
  end

  return result
end

print(maxResult(
  permutations({4, 3, 2, 1, 0}):
  map(signal)))
