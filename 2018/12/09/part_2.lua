local deque = require("deque")
local yulea = require("yulea")

local array = yulea.table.array
local cycle = yulea.iterator.cycle
local elements = yulea.table.elements
local maxResult = yulea.math.maxResult
local range = yulea.iterator.range
local rep = yulea.iterator.rep

local function parseInput(input)
  local players, points =
    input:match("^(%d+) players; last marble is worth (%d+) points$")

  return tonumber(players), tonumber(points)
end

local players, points = parseInput(io.read())
local scores = array(rep(0, players))
local turns = cycle(range(1, players))

local ring = deque.new()
ring:push_left(0)

for marble in range(1, 100 * points) do
  local player = turns()

  if marble % 23 == 0 then
    ring:rotate_right(7)
    scores[player] = scores[player] + marble + ring:pop_left()
  else
    ring:rotate_left(2)
    ring:push_left(marble)
  end
end

print(maxResult(elements(scores)))
