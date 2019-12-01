local yulea = require("yulea")

local map = yulea.iterator.map

local function parseClaim(line)
  local id, x, y, width, height =
    string.match(line, "#(%d+) @ (%d+),(%d+): (%d+)x(%d+)")

  return {
    id = tonumber(id),
    x = tonumber(x),
    y = tonumber(y),
    width = tonumber(width),
    height = tonumber(height),
  }
end

local fabric = {}

for claim in map(io.lines(), parseClaim) do
  for x = claim.x, claim.x + claim.width - 1 do
    fabric[x] = fabric[x] or {}

    for y = claim.y, claim.y + claim.height - 1 do
      fabric[x][y] = (fabric[x][y] or 0) + 1
    end
  end
end

local overlaps = 0

for x, column in pairs(fabric) do
  for y, count in pairs(column) do
    if count >= 2 then
      overlaps = overlaps + 1
    end
  end
end

print(overlaps)
