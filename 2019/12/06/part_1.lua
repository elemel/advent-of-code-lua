local yulea = require("yulea")

local keys = yulea.keys
local map = yulea.map
local sum = yulea.sum

local function depth(parents, object)
  local parent = parents[object]

  if not parent then
    return 0
  end

  return 1 + depth(parents, parent)
end

local parents = {}

for line in io.lines() do
  local parent, child = string.match(line, "^(...)%)(...)$")
  parents[child] = parent
end

print(sum(map(keys(parents), function(child)
  return depth(parents, child)
end)))
