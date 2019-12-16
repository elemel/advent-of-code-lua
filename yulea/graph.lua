local Queue = require("yulea.Queue")

local function breadthFirstSearch(neighborArrays, origin)
  local parents = {}
  parents[origin] = origin

  local queue = Queue.new()
  queue:push(origin)

  repeat
    local vertex = queue:pop()
    local neighbors = neighborArrays[vertex]

    if neighbors then
      for _, neighbor in ipairs(neighbors) do
        if parents[neighbor] == nil then
          parents[neighbor] = vertex
          queue:push(neighbor)
        end
      end
    end
  until queue:isEmpty()

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
