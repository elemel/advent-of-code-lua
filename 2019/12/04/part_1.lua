local yulea = require("yulea")

local array = yulea.table.array
local count = yulea.iterator.count
local digits = yulea.math.digits
local elements = yulea.table.elements
local firstDuplicate = yulea.iterator.firstDuplicate
local isSorted = yulea.table.isSorted
local range = yulea.iterator.range

local first, last = string.match(io.read(), "(%d+)-(%d+)")

local passwords = (range(tonumber(first), tonumber(last)):
  map(digits):
  filter(isSorted):
  filter(function(password)
    return firstDuplicate(elements(password)) ~= nil
  end))

print(#array(passwords))
