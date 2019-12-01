local yulea = require("yulea")

local map = yulea.iterator.map
local numbers = yulea.io.numbers
local sum = yulea.math.sum

local function fuel(mass)
  local result = math.floor(mass / 3) - 2

  if result <= 0 then
    return 0
  end

  return result + fuel(result)
end

print(sum(map(numbers(io.stdin), fuel)))
