local yulea = require("yulea")

local array = yulea.table.array
local elements = yulea.table.elements
local trim = yulea.string.trim
local split = yulea.string.split

local function reactive(a, b)
  return a ~= b and string.lower(a) == string.lower(b)
end

local function react(polymer, result)
  result = result or {}

  for unit in elements(polymer) do
    if #result >= 1 and reactive(unit, result[#result]) then
      table.remove(result)
    else
      table.insert(result, unit)
    end
  end

  return result
end

local polymer = array(split(trim(io.read("*a"))))
polymer = react(polymer)
print(#polymer)
