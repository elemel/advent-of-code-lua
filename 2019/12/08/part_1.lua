local yulea = require("yulea")

local array = yulea.array
local elements = yulea.elements
local map = yulea.map
local reduce = yulea.reduce
local split = yulea.split

local function countDigits(layer, digit)
  local result = 0

  for row in elements(layer) do
    for digit2 in elements(row) do
      if digit2 == digit then
        result = result + 1
      end
    end
  end

  return result
end

local width = 25
local height = 6
local pixels = array(map(split(io.read()), tonumber))

local layerCount = math.floor(#pixels / (width * height))
local image = {}

for z = 1, layerCount do
  image[z] = {}

  for y = 1, height do
    image[z][y] = {}

    for x = 1, width do
      image[z][y][x] = pixels[width * height * (z - 1) + width * (y - 1) + x]
    end
  end
end

local foundLayer = reduce(elements(image), function(a, b)
  return countDigits(a, 0) < countDigits(b, 0) and a or b
end)

print(countDigits(foundLayer, 1) * countDigits(foundLayer, 2))
