local deque = require("deque")

local parents = {}
local children = {}

for line in io.lines() do
  local parent, child = string.match(line, "^(...)%)(...)$")
  parents[child] = parent

  children[parent] = children[parent] or {}
  children[parent][child] = true
end

local origin = parents["YOU"]
local destination = parents["SAN"]

local queue = deque.new()
queue:push_right(origin)

local distances = {}
distances[origin] = 0

while not queue:is_empty() do
  local object = queue:pop_left()

  if object == destination then
    print(distances[destination])
    break
  end

  local parent = parents[object]

  if parent and not distances[parent] then
    distances[parent] = distances[object] + 1
    queue:push_right(parent)
  end

  if children[object] then
    for child in pairs(children[object]) do
      if not distances[child] then
        distances[child] = distances[object] + 1
        queue:push_right(child)
      end
    end
  end
end
