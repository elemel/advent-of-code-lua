local midwint = require("midwint")
local yulea = require("yulea")

local elements = yulea.elements
local maxResult = yulea.maxResult
local permutations = yulea.permutations

local function signal(source, phases)
  local amplifiers = {}

  for phase in elements(phases) do
    local amplifier = midwint.Program.new(source)
    amplifier.inputQueue:push(phase)
    amplifiers[#amplifiers + 1] = amplifier
  end

  for i, amplifier in ipairs(amplifiers) do
    local j = i % #amplifiers + 1
    amplifier.outputQueue = amplifiers[j].inputQueue
  end

  amplifiers[1].inputQueue:push(0)

  while true do
    local allHalted = true

    for amplifier in elements(amplifiers) do
      amplifier:run()
      allHalted = allHalted and amplifier:isHalted()
    end

    if allHalted then
      break
    end
  end

  return amplifiers[#amplifiers].outputQueue:pop()
end

local source = io.read()

print(maxResult(
  permutations({5, 6, 7, 8, 9}):
  map(function(phases)
    return signal(source, phases)
  end)))
