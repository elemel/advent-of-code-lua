local intcode = require("intcode")
local yulea = require("yulea")

local all = yulea.all
local elements = yulea.elements
local map = yulea.map
local maxResult = yulea.maxResult
local permutations = yulea.permutations

local function signal(source, phases)
  local amplifiers = {}

  for phase in elements(phases) do
    local amplifier = intcode.Program.new(source)
    amplifier:write(phase)
    amplifiers[#amplifiers + 1] = amplifier
  end

  for i, amplifier in ipairs(amplifiers) do
    local j = i % #amplifiers + 1
    amplifier.outputQueue = amplifiers[j].inputQueue
  end

  amplifiers[1]:write(0)

  repeat
    for amplifier in elements(amplifiers) do
      amplifier:run()
    end
  until all(map(
    elements(amplifiers),
    function(amplifier) return amplifier:isHalted() end))

  return amplifiers[#amplifiers]:read()
end

local source = io.read()

print(maxResult(map(
  permutations({5, 6, 7, 8, 9}),
  function(phases) return signal(source, phases) end)))
