local intcode = require("intcode")
local yulea = require("yulea")

local elements = yulea.elements
local enumerate = yulea.enumerate
local maxResult = yulea.maxResult
local permutations = yulea.permutations

function runAmplifiers(source, phases)
  local signal = 0

  for phase in elements(phases) do
    local program = intcode.compile(source)
    program.inputs = elements({phase, signal})
    program.outputs = function(value) signal = value end
    intcode.run(program)
  end

  return signal
end

local source = io.read()
local phases = {4, 3, 2, 1, 0}

print(maxResult(
  permutations(phases):
  map(function(permutedPhases)
    return runAmplifiers(source, permutedPhases)
  end)))
