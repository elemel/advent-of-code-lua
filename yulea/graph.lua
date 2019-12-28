local deque = require("yulea.deque")

local function breadthFirstSearch(neighborArrays, origin)
  local parents = {}
  parents[origin] = origin

  local queue = deque.new()
  queue:push_right(origin)

  repeat
    local vertex = queue:pop_left()
    local neighbors = neighborArrays[vertex]

    if neighbors then
      for _, neighbor in ipairs(neighbors) do
        if parents[neighbor] == nil then
          parents[neighbor] = vertex
          queue:push_right(neighbor)
        end
      end
    end
  until queue:is_empty()

  parents[origin] = nil
  return parents
end

local function depth(parents, vertex)
  for result = 0, math.huge do
    vertex = parents[vertex]

    if vertex == nil then
      return result
    end
  end
end

return {
  breadthFirstSearch = breadthFirstSearch,
  depth = depth,
}
