local yulea = require("yulea")

local enumerate = yulea.enumerate
local greatestCommonDivisor = yulea.greatestCommonDivisor
local split = yulea.split

local asteroids = {}

for y, line in enumerate(io.lines(), 0) do
  for x, char in enumerate(split(line), 0) do
    if char ~= "." then
      asteroids[y] = asteroids[y] or {}
      asteroids[y][x] = char
    end
  end
end

local maxCount = -math.huge
local bestLocationX, bestLocationY

for y1, row1 in pairs(asteroids) do
  for x1, char1 in pairs(row1) do
    local seen = {}
    local count = 0

    for y2, row2 in pairs(asteroids) do
      for x2, char2 in pairs(row2) do
        if x2 ~= x1 or y2 ~= y1 then
          local dx = x2 - x1
          local dy = y2 - y1

          local d = greatestCommonDivisor(dx, dy)

          dx = dx / d
          dy = dy / d

          if not seen[dy] or not seen[dy][dx] then
            seen[dy] = seen[dy] or {}
            seen[dy][dx] = true

            count = count + 1
          end
        end
      end
    end

    if count > maxCount then
      maxCount = count
      bestLocationX = x1
      bestLocationY = y1
    end
  end
end

-- print(bestLocationX, bestLocationY)
print(maxCount)
