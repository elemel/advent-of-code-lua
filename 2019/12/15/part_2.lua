local deque = require("deque")
local midwint = require("midwint")
local yulea = require("yulea")

local breadthFirstSearch = yulea.breadthFirstSearch
local depth = yulea.depth
local getCell = yulea.getCell
local keys = yulea.keys
local map = yulea.map
local maxResult = yulea.maxResult
local printGrid = yulea.printGrid
local setCell = yulea.setCell
local unpack = unpack or table.unpack

local function key(x, y)
  return string.format("%d,%d", x, y)
end

local commands = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}}
local backtrackInstructions = {2, 1, 4, 3}

local program = midwint.Program.new(io.read())

local queue = deque.new()
queue:push_right({0, 0, 0, program})

local grid = {}
setCell(grid, 0, 0, ".")

local oxygenSystemX, oxygenSystemY
local graph = {}

local function search(x, y)
  for instruction, direction in ipairs(commands) do
    local dx, dy = unpack(direction)
    local char = grid[y + dy] and grid[y + dy][x + dx]

    if not char then
      program.inputQueue:push(instruction)
      program:run()
      local status = program.outputQueue:pop()

      if status == 0 then
        setCell(grid, x + dx, y + dy, "#")
      elseif status == 1 or status == 2 then
        if status == 2 then
          oxygenSystemX = x + dx
          oxygenSystemY = y + dy
        end

        setCell(grid, x + dx, y + dy, ".")
        search(x + dx, y + dy)

        program.inputQueue:push(backtrackInstructions[instruction])
        program:run()
        assert(program.outputQueue:pop() ~= 0)
      else
        error("Invalid status")
      end
    elseif char == "." then
      local key1 = key(x, y)
      local key2 = key(x + dx, y + dy)

      graph[key1] = graph[key1] or {}
      table.insert(graph[key1], key2)

      graph[key2] = graph[key2] or {}
      table.insert(graph[key2], key1)
    end
  end
end

search(0, 0)
local parents = breadthFirstSearch(graph, key(oxygenSystemX, oxygenSystemY))

print(maxResult(map(
  keys(parents),
  function(k) return depth(parents, k) end)))
