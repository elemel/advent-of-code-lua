local heap = require("skew_heap")
local yulea = require("yulea")

local array = yulea.table.array
local compare = yulea.table.compare
local elements = yulea.table.elements
local keys = yulea.table.keys
local map = yulea.iterator.map
local memoize = yulea.table.memoize

local function parseRequirement(line)
  return {string.match(
    line, "Step (.) must be finished before step (.) can begin%.")}
end

local function duration(step)
  return 60 + string.byte(step) - string.byte('A') + 1
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

local time = 0
local idle = 5
local inProgress = heap:new(compare)
local completed = {}

while not available:empty() or not inProgress:empty() do
  while not available:empty() and idle >= 1 do
    idle = idle - 1
    local step = available:pop()
    inProgress:insert({time + duration(step), step}, true)
  end

  local key = inProgress:pop()
  local step
  time, step = table.unpack(key)
  idle = idle + 1

  table.insert(completed, step)

  for output in keys(outputs[step]) do
    inputs[output][step] = nil

    if not next(inputs[output]) then
      available:insert(output, true)
    end
  end
end

print(time)
