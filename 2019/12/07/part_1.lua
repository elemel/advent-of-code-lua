local intcode = require("intcode")
local yulea = require("yulea")

local elements = yulea.elements
local map = yulea.map
local maxResult = yulea.maxResult
local permutations = yulea.permutations

local function signal(source, phases)
  local result = 0

  for phase in elements(phases) do
    local amplifier = intcode.Program.new(source)

    amplifier.inputQueue:push_right(phase)
    amplifier.inputQueue:push_right(result)

    amplifier:run()
    result = amplifier.outputQueue:pop_left()
  end

  return result
end

local source = io.read()

print(maxResult(map(
  permutations({4, 3, 2, 1, 0}),
  function(phases) return signal(source, phases) end)))
