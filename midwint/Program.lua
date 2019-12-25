local Queue = require("midwint.Queue")

local function read(program, param)
  local opcode = program.memory[program.instructionPointer] or 0
  local divisor = 10 ^ (param + 1)
  local mode = math.floor(opcode / divisor) % 10
  local address = program.memory[program.instructionPointer + param] or 0

  if mode == 0 then
    return program.memory[address] or 0
  elseif mode == 1 then
    return address
  elseif mode == 2 then
    return program.memory[program.relativeBase + address] or 0
  else
    error("Invalid parameter mode")
  end
end

local function write(program, param, value)
  local opcode = program.memory[program.instructionPointer] or 0
  local divisor = 10 ^ (param + 1)
  local mode = math.floor(opcode / divisor) % 10
  local address = program.memory[program.instructionPointer + param] or 0

  if mode == 0 then
    program.memory[address] = value
  elseif mode == 2 then
    program.memory[program.relativeBase + address] = value
  else
    error("Invalid parameter mode")
  end
end

local function add(program)
  local left = read(program, 1)
  local right = read(program, 2)

  local result = left + right
  write(program, 3, result)
  program.instructionPointer = program.instructionPointer + 4
end

local function multiply(program)
  local left = read(program, 1)
  local right = read(program, 2)

  local result = left * right
  write(program, 3, result)
  program.instructionPointer = program.instructionPointer + 4
end

local function input(program)
  local value = program.inputQueue:pop()
  write(program, 1, value)
  program.instructionPointer = program.instructionPointer + 2
end

local function output(program)
  local value = read(program, 1)
  program.outputQueue:push(value)
  program.instructionPointer = program.instructionPointer + 2
end

local function jumpIfTrue(program)
  local value = read(program, 1)
  local address = read(program, 2)

  if value ~= 0 then
    program.instructionPointer = address
  else
    program.instructionPointer = program.instructionPointer + 3
  end
end

local function jumpIfFalse(program)
  local value = read(program, 1)
  local address = read(program, 2)

  if value == 0 then
    program.instructionPointer = address
  else
    program.instructionPointer = program.instructionPointer + 3
  end
end

local function lessThan(program)
  local left = read(program, 1)
  local right = read(program, 2)

  local result = left < right and 1 or 0
  write(program, 3, result)
  program.instructionPointer = program.instructionPointer + 4
end

local function equals(program)
  local left = read(program, 1)
  local right = read(program, 2)

  local result = left == right and 1 or 0
  write(program, 3, result)
  program.instructionPointer = program.instructionPointer + 4
end

local function adjustRelativeBase(program)
  local value = read(program, 1)
  program.relativeBase = program.relativeBase + value
  program.instructionPointer = program.instructionPointer + 2
end

local function halt(program)
  program.instructionPointer = nil
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
  [9] = adjustRelativeBase,
  [99] = halt,
}

local instructionSizes = {
  [1] = 4,
  [2] = 4,
  [3] = 2,
  [4] = 2,
  [5] = 3,
  [6] = 3,
  [7] = 4,
  [8] = 4,
  [9] = 2,
  [99] = 1,
}

local Program = {}
Program.__index = Program

function Program.new(source)
  local program = {
    memory = {},
  }

  local address = 0

  for s in string.gmatch(source, "-?%d+") do
    program.memory[address] = tonumber(s)
    address = address + 1
  end

  program.instructionPointer = 0
  program.relativeBase = 0

  program.inputQueue = Queue.new()
  program.outputQueue = Queue.new()

  program.breakpoints = {}
  program.labels = {}
  program.watches = {"ip", "rb", "iq", "oq"}

  program.data = {}
  program.instructions = {}
  program.parameters = {}

  return setmetatable(program, Program)
end

function Program:step()
  if not self.instructionPointer then
    return false
  end

  local opcode = self.memory[self.instructionPointer] or 0
  opcode = opcode % 100

  if opcode == 3 and self.inputQueue:isEmpty() then
    return false
  end

  local operation = assert(operations[opcode], "Invalid opcode")

  if not self.instructions[self.instructionPointer] then
    self.instructions[self.instructionPointer] = 1

    for i = 1, instructionSizes[opcode] - 1 do
      self.parameters[self.instructionPointer + i] = true
    end
  else
    self.instructions[self.instructionPointer] =
      self.instructions[self.instructionPointer] + 1
  end

  operation(self)
  return true
end

function Program:run()
  for result = 0, math.huge do
    if not self:step() or self.breakpoints[self.instructionPointer] then
      return result
    end
  end
end

function Program:isBlocked()
  local opcode =
    self.instructionPointer and self.memory[self.instructionPointer] or 0

  return opcode % 100 == 3 and self.inputQueue:isEmpty()
end

function Program:isHalted()
  return self.instructionPointer == nil
end

function Program:clone()
  local program = {
    memory = {},
  }

  for address = 0, #self.memory do
    program.memory[address] = self.memory[address]
  end

  program.instructionPointer = self.instructionPointer
  program.relativeBase = self.relativeBase

  program.inputQueue = Queue.new()
  program.outputQueue = Queue.new()

  program.breakpoints = {}
  program.labels = {}
  program.watches = {"ip", "rb", "iq", "oq"}

  program.data = {}
  program.instructions = {}
  program.parameters = {}

  return setmetatable(program, Program)
end

return Program
