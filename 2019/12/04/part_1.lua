local yulea = require("yulea")

local count = yulea.count
local digits = yulea.digits
local elements = yulea.elements
local firstDuplicate = yulea.firstDuplicate
local isSorted = yulea.isSorted
local range = yulea.range

local first, last = string.match(io.read(), "(%d+)-(%d+)")

print(count(
  range(tonumber(first), tonumber(last)):
  map(digits):
  filter(isSorted):
  filter(function(password)
    return firstDuplicate(elements(password)) ~= nil
  end)))
