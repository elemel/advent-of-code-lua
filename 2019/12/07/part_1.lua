local midwint = require("midwint")
local yulea = require("yulea")

local elements = yulea.elements
local map = yulea.map
local maxResult = yulea.maxResult
local permutations = yulea.permutations

local function signal(source, phases)
  local result = 0

  for phase in elements(phases) do
    local amplifier = midwint.Program.new(source)

    amplifier.inputQueue:push(phase)
    amplifier.inputQueue:push(result)

    amplifier:run()
    result = amplifier.outputQueue:pop()
  end

  return result
end

local source = io.read()

print(maxResult(map(
  permutations({4, 3, 2, 1, 0}),
  function(phases) return signal(source, phases) end)))
