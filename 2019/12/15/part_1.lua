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

while not queue:is_empty() do
  local step, x, y, program1 = table.unpack(queue:pop_left())

  if not visited[y] or not visited[y][x] then
    visited[y] = visited[y] or {}
    visited[y][x] = true

    for instruction, direction in ipairs(commands) do
      local dx, dy = table.unpack(direction)

      local char = map[y + dy] and map[y + dy][x + dx]

      if not char then
        program2 = program1:clone()
        program2.inputQueue:push(instruction)
        program2:run()
        local status = program2.outputQueue:pop()

        if status == 0 then
          map[y + dy] = map[y + dy] or {}
          map[y + dy][x + dx] = "#"
        elseif status == 1 then
          map[y + dy] = map[y + dy] or {}
          map[y + dy][x + dx] = "."

          queue:push_left({step + 1, x + dx, y + dy, program2})
        elseif status == 2 then
          print(step + 1)
          return
        else
          error("Invalid status")
        end
      end
    end
  end
end
