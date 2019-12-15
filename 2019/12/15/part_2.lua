local deque = require("deque")
local midwint = require("midwint")

local commands = {{0, -1}, {0, 1}, {-1, 0}, {1, 0}}
local program = midwint.Program.new(io.read())

local queue = deque.new()
queue:push_right({0, 0, 0, program})

local map = {}
map[0] = {}
map[0][0] = "."

local visited = {}

local oxygenSystemX, oxygenSystemY

while not queue:is_empty() do
  local step, x, y, program = table.unpack(queue:pop_left())

  if not visited[y] or not visited[y][x] then
    visited[y] = visited[y] or {}
    visited[y][x] = true

    for instruction, direction in ipairs(commands) do
      local dx, dy = table.unpack(direction)
      local char = map[y + dy] and map[y + dy][x + dx]

      if not char then
        program2 = program:clone()
        program2.inputQueue:push(instruction)
        program2:run()
        local status = program2.outputQueue:pop()

        if status == 0 then
          map[y + dy] = map[y + dy] or {}
          map[y + dy][x + dx] = "#"
        elseif status == 1 or status == 2 then
          if status == 2 then
            oxygenSystemX = x + dx
            oxygenSystemY = y + dy
          end

          map[y + dy] = map[y + dy] or {}
          map[y + dy][x + dx] = "."

          queue:push_left({step + 1, x + dx, y + dy, program2})
        else
          error("Invalid status")
        end
      end
    end
  end
end

local oxygenQueue = deque.new()
oxygenQueue:push_right({0, oxygenSystemX, oxygenSystemY})
local maxTime = -math.huge

while not oxygenQueue:is_empty() do
  local time, x, y = table.unpack(oxygenQueue:pop_left())

  if map[y][x] == "." then
    map[y][x] = "O"
    maxTime = math.max(maxTime, time)

    for _, direction in ipairs(commands) do
      local dx, dy = table.unpack(direction)

      oxygenQueue:push_right({time + 1, x + dx, y + dy})
    end
  end
end

print(maxTime)
