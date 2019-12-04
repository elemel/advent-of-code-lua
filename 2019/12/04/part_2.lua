local yulea = require("yulea")

local array = yulea.table.array
local digits = yulea.math.digits
local elements = yulea.table.elements
local filter = yulea.iterator.filter
local findValue = yulea.table.findValue
local histogram = yulea.table.histogram
local isSorted = yulea.table.isSorted
local map = yulea.iterator.map
local range = yulea.iterator.range
local values = yulea.table.values

local function hasFrequency(password, n)
  n = n or 2
  return findValue(histogram(elements(password)), n) ~= nil
end

local first, last = string.match(io.read(), "(%d+)-(%d+)")

print(#array(filter(
  filter(
    map(
      range(tonumber(first), tonumber(last)),
      digits),
    isSorted),
  hasFrequency)))
