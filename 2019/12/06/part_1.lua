local yulea = require("yulea")

local count = yulea.count
local keys = yulea.keys
local map = yulea.map
local sum = yulea.sum

local parents = {}

for line in io.lines() do
  local parent, child = string.match(line, "^(...)%)(...)$")
  parents[child] = parent
end

local function ancestors(object)
  return function()
    object = parents[object]
    return object
  end
end

print(sum(
  keys(parents):
  map(ancestors):
  map(count)))
