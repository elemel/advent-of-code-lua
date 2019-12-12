local yulea = require("yulea")

local elements = yulea.elements
local map = yulea.map
local sum = yulea.sum

local function parseVector(line)
  local x, y, z = string.match(line, "<x=(-?%d+), y=(-?%d+), z=(-?%d+)>")
  return tonumber(x), tonumber(y), tonumber(z)
end

local function applyGravity(moon1, moon2)
  for axis = 1, 3 do
    if moon1.position[axis] < moon2.position[axis] then
      moon1.velocity[axis] = moon1.velocity[axis] + 1
      moon2.velocity[axis] = moon2.velocity[axis] - 1
    elseif moon1.position[axis] > moon2.position[axis] then
      moon1.velocity[axis] = moon1.velocity[axis] - 1
      moon2.velocity[axis] = moon2.velocity[axis] + 1
    end
  end
end

local function applyVelocity(moon)
  for axis = 1, 3 do
    moon.position[axis] = moon.position[axis] + moon.velocity[axis]
  end
end

local moons = {}

for line in io.lines() do
  local position = {parseVector(line)}

  local moon = {
    position = position,
    velocity = {0, 0, 0},
  }

  table.insert(moons, moon)
end

for step = 1, 1000 do
  for i = 1, #moons - 1 do
    for j = i + 1, #moons do
      applyGravity(moons[i], moons[j])
    end
  end

  for _, moon in ipairs(moons) do
    applyVelocity(moon)
  end
end

print(sum(map(
  elements(moons),
  function(moon)
    local potentialEnergy = sum(map(elements(moon.position), math.abs))
    local kineticEnergy = sum(map(elements(moon.velocity), math.abs))

    return potentialEnergy * kineticEnergy
  end)))
