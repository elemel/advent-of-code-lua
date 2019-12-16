local yulea = require("yulea")

local cycle = yulea.cycle
local join = yulea.join
local map = yulea.map
local slice = yulea.slice
local split = yulea.split
local toArray = yulea.toArray

local line = io.read()

local offset = tonumber(string.sub(line, 1, 7))
local input = toArray(map(split(line), tonumber))
local signal = {}

for i = offset + 1, 10000 * #input do
  signal[#signal + 1] = input[(i - 1) % #input + 1]
end

for phase = 1, 100 do
  local total = 0

  for i = #signal, 1, -1 do
    total = (total + signal[i]) % 10
    signal[i] = total
  end
end

print(join(slice(signal, 1, 8)))
