local yulea = require("yulea")

local array = yulea.table.array
local bind = yulea.functional.bind
local flatMap = yulea.iterator.flatMap
local index = yulea.functional.index
local map = yulea.iterator.map
local numbers = yulea.io.numbers
local rep = yulea.iterator.rep
local sum = yulea.math.sum
local take = yulea.iterator.take

local function value(nums)
  local childCount = nums()
  local metadataCount = nums()

  if childCount == 0 then
    return sum(take(nums, metadataCount))
  end

  local childValues = array(map(rep(nums, childCount), value))
  return sum(flatMap(take(nums, metadataCount), bind(index, childValues)))
end

print(value(numbers(io.stdin)))
