local yulea = require("yulea")

local map = yulea.iterator.map
local numbers = yulea.io.numbers
local sum = yulea.math.sum

local function fuel(mass)
  return math.floor(mass / 3) - 2
end

print(sum(map(numbers(io.stdin), fuel)))
