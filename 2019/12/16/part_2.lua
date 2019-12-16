local yulea = require("yulea")

local cycle = yulea.cycle
local join = yulea.join
local map = yulea.map
local slice = yulea.slice
local split = yulea.split
local toArray = yulea.toArray

local line = io.read()

local offset = tonumber(string.sub(line, 1, 7))
local input = toArray(cycle(map(split(line), tonumber), 10000))

for phase = 1, 100 do
  local total = 0

  for i = #input, offset, -1 do
    total = (total + input[i]) % 10
    input[i] = total
  end
end

print(join(slice(input, offset + 1, offset + 8)))
