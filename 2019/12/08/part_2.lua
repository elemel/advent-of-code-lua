local yulea = require("yulea")

local array = yulea.array
local elements = yulea.elements
local join = yulea.join
local map = yulea.map
local range = yulea.range
local split = yulea.split

local function findColor(image, x, y)
  for layer in elements(image) do
    if layer[y][x] ~= 2 then
      return layer[y][x]
    end
  end

  return 2
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

for y = 1, height do
  print(join(
    range(1, width)
    :map(function(x)
      return findColor(image, x, y) == 1 and "#" or " "
    end)))
end
