local yulea = require("yulea")

local array = yulea.table.array
local digits = yulea.math.digits
local elements = yulea.table.elements
local filter = yulea.iterator.filter
local firstDuplicate = yulea.iterator.firstDuplicate
local isSorted = yulea.table.isSorted
local map = yulea.iterator.map
local range = yulea.iterator.range

local function hasDuplicates(password)
  return firstDuplicate(elements(password)) ~= nil
end

local first, last = string.match(io.read(), "(%d+)-(%d+)")

print(#array(filter(
  filter(
    map(
      range(tonumber(first), tonumber(last)),
      digits),
    isSorted),
  hasDuplicates)))
