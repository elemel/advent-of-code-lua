local yulea = require("yulea")

local enumerate = yulea.enumerate
local gcd = yulea.gcd
local split = yulea.split

local grid = {}

for y, line in enumerate(io.lines(), 0) do
  grid[y] = {}

  for x, char in enumerate(split(line), 0) do
    grid[y][x] = char
  end
end

local minX = 0
local minY = 0

local maxX = #grid[0]
local maxY = #grid

local maxCount = -math.huge
local bestLocationX, bestLocationY

for y = minY, maxY do
  for x = minX, maxX do
    if grid[y][x] ~= "." then
      local seen = {}
      local count = 0

      for y2 = minY, maxY do
        for x2 = minX, maxX do
          if (x2 ~= x or y2 ~= y) and grid[y2][x2] ~= "." then
            local dx = x2 - x
            local dy = y2 - y

            local d = gcd(dx, dy)

            dx = dx / d
            dy = dy / d

            if not (seen[dy] and seen[dy][dx]) then
              seen[dy] = seen[dy] or {}
              seen[dy][dx] = true

              count = count + 1
            end
          end
        end
      end

      if count > maxCount then
        maxCount = count
        bestLocationX = x
        bestLocationY = y
      end
    end
  end
end

-- print(bestLocationX, bestLocationY)
print(maxCount)
