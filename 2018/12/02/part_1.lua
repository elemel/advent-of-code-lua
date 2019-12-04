local yulea = require("yulea")

local bytes = yulea.string.bytes
local distinct = yulea.iterator.distinct
local histogram = yulea.table.histogram
local values = yulea.table.values

local counts = {}

for line in io.lines() do
  histogram(distinct(values(histogram(bytes(line)))), counts)
end

print((counts[2] or 0) * (counts[3] or 0))
