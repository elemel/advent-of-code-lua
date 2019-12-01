local yulea = require("yulea")

local map = yulea.iterator.map
local numbers = yulea.io.numbers
local rep = yulea.iterator.rep
local sum = yulea.math.sum
local take = yulea.iterator.take

local function checksum(nums)
  local childCount = nums()
  local metadataCount = nums()

  local childChecksum = sum(map(rep(nums, childCount), checksum))
  local metadataChecksum = sum(take(nums, metadataCount))

  return childChecksum + metadataChecksum
end

print(checksum(numbers(io.stdin)))
