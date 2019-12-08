local Queue = require("midwint.Queue")

local function read(program, param)
  local divisor = 10 ^ (param + 1)
  local mode = math.floor(program[program.ip] / divisor) % 10
  local address = program[program.ip + param]
  return mode == 0 and program[address] or address
end

local function write(program, param, value)
  local address = program[program.ip + param]
  program[address] = value
end

local function add(program)
  local left = read(program, 1)
  local right = read(program, 2)

  local result = left + right
  write(program, 3, result)
  program.ip = program.ip + 4
end

local function multiply(program)
  local left = read(program, 1)
  local right = read(program, 2)

  local result = left * right
  write(program, 3, result)
  program.ip = program.ip + 4
end

local function input(program)
  local value = program.inputs:pop()
  write(program, 1, value)
  program.ip = program.ip + 2
end

local function output(program)
  local value = read(program, 1)
  program.outputs:push(value)
  program.ip = program.ip + 2
end

local function jumpIfTrue(program)
  local value = read(program, 1)
  local address = read(program, 2)
  program.ip = value ~= 0 and address or program.ip + 3
end

local function jumpIfFalse(program)
  local value = read(program, 1)
  local address = read(program, 2)
  program.ip = value == 0 and address or program.ip + 3
end

local function lessThan(program)
  local left = read(program, 1)
  local right = read(program, 2)

  local result = left < right and 1 or 0
  write(program, 3, result)
  program.ip = program.ip + 4
end

local function equals(program)
  local left = read(program, 1)
  local right = read(program, 2)

  local result = left == right and 1 or 0
  write(program, 3, result)
  program.ip = program.ip + 4
end

local function halt(program)
  program.ip = nil
end

local operations = {
  [1] = add,
  [2] = multiply,
  [3] = input,
  [4] = output,
  [5] = jumpIfTrue,
  [6] = jumpIfFalse,
  [7] = lessThan,
  [8] = equals,
  [99] = halt,
}

local Program = {}
Program.__index = Program

function Program.new(source)
  local program = {}
  local address = 0

  for s in string.gmatch(source, "-?%d+") do
    program[address] = tonumber(s)
    address = address + 1
  end

  program.ip = 0

  program.inputs = Queue.new()
  program.outputs = Queue.new()

  return setmetatable(program, Program)
end

function Program:step()
  if not self.ip then
    return false
  end

  local opcode = self[self.ip] % 100

  if opcode == 3 and self.inputs:isEmpty() then
    return false
  end

  local operation = assert(operations[opcode], "Invalid opcode")
  operation(self)

  return true
end

function Program:run()
  for result = 0, math.huge do
    if not self:step() then
      return result
    end
  end
end

return Program
