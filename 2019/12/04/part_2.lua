local yulea = require("yulea")

local count = yulea.count
local digits = yulea.digits
local elements = yulea.elements
local findValue = yulea.findValue
local histogram = yulea.histogram
local isSorted = yulea.isSorted
local range = yulea.range
local stream = yulea.stream
local values = yulea.values

local first, last = string.match(io.read(), "(%d+)-(%d+)")

print(count(
  stream(range(tonumber(first), tonumber(last))):
  map(digits):
  filter(isSorted):
  filter(function(password)
    return findValue(histogram(elements(password)), 2) ~= nil
  end)))
