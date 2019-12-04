local yulea = require("yulea")

local count = yulea.iterator.count
local digits = yulea.math.digits
local elements = yulea.table.elements
local findValue = yulea.table.findValue
local histogram = yulea.table.histogram
local isSorted = yulea.table.isSorted
local range = yulea.iterator.range
local values = yulea.table.values

local first, last = string.match(io.read(), "(%d+)-(%d+)")

print(count(range(tonumber(first), tonumber(last)):
  map(digits):
  filter(isSorted):
  filter(function(password)
    return findValue(histogram(elements(password)), 2) ~= nil
  end)))
