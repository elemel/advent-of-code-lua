local midwint = require("midwint")
local yulea = require("yulea")


local function turnLeft(dx, dy)
  return dy, -dx
end

local function turnRight(dx, dy)
  return -dy, dx
end

local turners = {
  [0] = turnLeft,
  [1] = turnRight,
}

local program = midwint.Program.new(io.read())

local x = 0
local y = 0

local dx = 0
local dy = -1

local grid = {}
local count = 0

repeat
  grid[y] = grid[y] or {}
  program.inputQueue:push(grid[y][x] or 0)
  program:run()

  if not grid[y][x] then
    count = count + 1
  end

  grid[y][x] = program.outputQueue:pop()
  local turn = program.outputQueue:pop()
  dx, dy = turners[turn](dx, dy)

  x = x + dx
  y = y + dy
until program:isHalted()

print(count)
