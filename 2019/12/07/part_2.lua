local intcode = require("intcode")
local yulea = require("yulea")

local elements = yulea.elements
local maxResult = yulea.maxResult
local permutations = yulea.permutations

local source = io.read()

local function signal(phases)
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

  local allHalted

  repeat
    allHalted = true

    for amplifier in elements(amplifiers) do
      intcode.run(amplifier)
      allHalted = allHalted and amplifier.ip == nil
    end
  until allHalted

  return amplifiers[#amplifiers].outputs:pop_left()
end

print(maxResult(
  permutations({5, 6, 7, 8, 9}):
  map(signal)))
