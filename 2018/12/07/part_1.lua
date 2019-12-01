local heap = require("skew_heap")
local yulea = require("yulea")

local array = yulea.table.array
local elements = yulea.table.elements
local keys = yulea.table.keys
local map = yulea.iterator.map
local memoize = yulea.table.memoize

local function parseRequirement(line)
  return {string.match(
    line, "Step (.) must be finished before step (.) can begin%.")}
end

local requirements = array(map(io.lines(), parseRequirement))

local inputs = memoize(function(k) return {} end)
local outputs = memoize(function(k) return {} end)

for requirement in elements(requirements) do
  local input, output = table.unpack(requirement)

  inputs[output][input] = true
  outputs[input][output] = true
end

local available = heap:new()

for step in keys(outputs) do
  if not next(inputs[step]) then
    available:insert(step, true)
  end
end

local completed = {}

while not available:empty() do
  local step = available:pop()
  table.insert(completed, step)

  for output in keys(outputs[step]) do
    inputs[output][step] = nil

    if not next(inputs[output]) then
      available:insert(output, true)
    end
  end
end

print(table.concat(completed))
