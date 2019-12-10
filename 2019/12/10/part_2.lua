local yulea = require("yulea")

local enumerate = yulea.enumerate
local compareDirections = yulea.compareDirections
local gcd = yulea.gcd
local split = yulea.split
local squaredDistance = yulea.squaredDistance

local x0 = 31
local y0 = 20

local asteroids = {}
local expectedVaporizations = {}

for y, line in enumerate(io.lines(), 0) do
  for x, char in enumerate(split(line), 0) do
    if char ~= "." then
      asteroids[y] = asteroids[y] or {}
      asteroids[y][x] = char

      if char == "X" then
        x0 = x
        y0 = y
      end

      if string.match(char, "%d") then
        expectedVaporizations[tonumber(char)] = {x, y}
      end
    end
  end
end

local rays = {}

for y, row in pairs(asteroids) do
  for x, char in pairs(row) do
    if x ~= x0 or y ~= y0 then
      local dx = x - x0
      local dy = y - y0

      local d = gcd(dx, dy)

      dx = dx / d
      dy = dy / d

      rays[dy] = rays[dy] or {}
      rays[dy][dx] = rays[dy][dx] or {}
      table.insert(rays[dy][dx], {x, y})
    end
  end
end

local vaporizations = {}

for dy, row in pairs(rays) do
  for dx, positions in pairs(row) do
    table.sort(positions, function(position1, position2)
      return (squaredDistance(x0, y0, table.unpack(position1)) <
        squaredDistance(x0, y0, table.unpack(position2)))
    end)

    for z, position in ipairs(positions) do
      table.insert(vaporizations, {z, dx, dy, table.unpack(position)})
    end
  end
end

table.sort(vaporizations, function(vaporization1, vaporization2)
  local z1, dx1, dy1 = table.unpack(vaporization1)
  local z2, dx2, dy2 = table.unpack(vaporization2)

  if z1 ~= z2 then
    return z1 < z2
  end

  return compareDirections(-dy1, dx1, -dy2, dx2)
end)

for i, expectedVaporization in ipairs(expectedVaporizations) do
  local expectedX, expectedY = table.unpack(expectedVaporization)
  local _, _, _, actualX, actualY = table.unpack(vaporizations[i])

  print(expectedX .. "," .. expectedY)
  assert(actualX == expectedX and actualY == expectedY)
end

if #vaporizations >= 200 then
  local _, _, _, x, y = table.unpack(vaporizations[200])
  print(100 * x + y)
end
