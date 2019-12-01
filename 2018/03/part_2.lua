local yulea = require("yulea")

local array = yulea.table.array
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

local function overlaps(claim, fabric)
  for x = claim.x, claim.x + claim.width - 1 do
    for y = claim.y, claim.y + claim.height - 1 do
      if fabric[x][y] >= 2 then
        return true
      end
    end
  end

  return false
end

local claims = array(map(io.lines(), parseClaim))
local fabric = {}

for _, claim in ipairs(claims) do
  for x = claim.x, claim.x + claim.width - 1 do
    fabric[x] = fabric[x] or {}

    for y = claim.y, claim.y + claim.height - 1 do
      fabric[x][y] = (fabric[x][y] or 0) + 1
    end
  end
end

for _, claim in ipairs(claims) do
  if not overlaps(claim, fabric) then
    print(claim.id)
  end
end
