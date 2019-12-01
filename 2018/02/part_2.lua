local yulea = require("yulea")

local array = yulea.table.array
local range = yulea.iterator.range

local function match(a, b)
  if #a ~= #b then
    return nil
  end

  local j

  for i = 1, #a do
    if string.byte(a, i) ~= string.byte(b, i) then
      if j then
        return nil
      end

      j = i
    end
  end

  return string.sub(a, 1, j - 1) .. string.sub(a, j + 1)
end

local lines = array(io.lines())

for i = 1, #lines - 1 do
  for j = i + 1, #lines do
    local common = match(lines[i], lines[j])

    if common then
      print(common)
    end
  end
end
