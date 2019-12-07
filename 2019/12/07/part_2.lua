local deque = require("deque")
local intcode = require("intcode")
local yulea = require("yulea")

local cycle = yulea.cycle
local elements = yulea.elements
local maxResult = yulea.maxResult
local permutations = yulea.permutations

function runAmplifiers(source, phases)
  local queues = {}

  for i, phase in ipairs(phases) do
    local queue = deque.new()
    queue:push_right(phase)
    queues[#queues + 1] = queue
  end

  queues[1]:push_right(0)

  local amplifiers = {}

  for i, phase in ipairs(phases) do
    local amplifier = coroutine.wrap(function()
      local program = intcode.compile(source)
      local inputQueue = queues[i]
      local outputQueue = queues[i + 1] or queues[1]

      program.inputs = function()
        while inputQueue:is_empty() do
          coroutine.yield("input")
        end

        return inputQueue:pop_left()
      end

      program.outputs = function(value)
        outputQueue:push_right(value)
        coroutine.yield("output")
      end

      intcode.run(program)
    end)

    table.insert(amplifiers, amplifier)
  end

  for amplifier in cycle(elements(amplifiers)) do
    if not amplifier() then
      return queues[1]:pop_left()
    end
  end
end

local source = io.read()
local phases = {5, 6, 7, 8, 9}

print(maxResult(
  permutations(phases):
  map(function(permutedPhases)
    return runAmplifiers(source, permutedPhases)
  end)))
