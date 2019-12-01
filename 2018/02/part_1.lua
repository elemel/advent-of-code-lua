local yulea = require("yulea")

local bytes = yulea.string.bytes
local distinct = yulea.iterator.distinct
local multiset = yulea.table.multiset
local values = yulea.table.values

local countCounts = {}

for line in io.lines() do
  multiset(distinct(values(multiset(bytes(line)))), countCounts)
end

print((countCounts[2] or 0) * (countCounts[3] or 0))
