local intcode = require("intcode")
local yulea = require("yulea")

local elements = yulea.elements
local maxResult = yulea.maxResult
local permutations = yulea.permutations

local function signal(source, phases)
  local amplifiers = {}

  for phase in elements(phases) do
    local amplifier = intcode.compile(source)
    amplifier.inputs:push_right(phase)
    amplifiers[#amplifiers + 1] = amplifier
  end

  for i, amplifier in ipairs(amplifiers) do
    local j = i % #amplifiers + 1
    amplifier.outputs = amplifiers[j].inputs
  end

  amplifiers[1].inputs:push_right(0)

  while true do
    local allHalted = true

    for amplifier in elements(amplifiers) do
      intcode.run(amplifier)
      allHalted = allHalted and amplifier.ip == nil
    end

    if allHalted then
      break
    end
  end

  return amplifiers[#amplifiers].outputs:pop_left()
end

local source = io.read()

print(maxResult(
  permutations({5, 6, 7, 8, 9}):
  map(function(phases)
    return signal(source, phases)
  end)))
