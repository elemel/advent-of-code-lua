local deque = require("deque")

local function readNumber()
  return io.read("*number")
end

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
  local value = assert(program.inputs:pop_left(), "Empty input")
  write(program, 1, value)
  program.ip = program.ip + 2
end

local function output(program)
  local value = read(program, 1)
  program.outputs:push_right(value)
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

local function step(program)
  if not program.ip then
    return false
  end

  local opcode = program[program.ip] % 100

  if opcode == 3 and program.inputs:is_empty() then
    return false
  end

  local operation = assert(operations[opcode], "Invalid opcode")
  operation(program)

  return true
end

local function run(program)
  for result = 0, math.huge do
    if not step(program) then
      return result
    end
  end
end

local operationNames = {
  [1] = "add",
  [2] = "multiply",
  [3] = "input",
  [4] = "output",
  [5] = "jumpIfTrue",
  [6] = "jumpIfFalse",
  [7] = "lessThan",
  [8] = "equals",
  [99] = "halt",
}

local function list(program)
  local opcode = program[program.ip] % 100
  print(program.ip, operationNames[opcode] or opcode)
end

local function compile(source)
  local program = {}
  local address = 0

  for s in string.gmatch(source, "-?%d+") do
    program[address] = tonumber(s)
    address = address + 1
  end

  program.ip = 0

  program.inputs = deque.new()
  program.outputs = deque.new()

  return program
end

return {
  compile = compile,
  list = list,
  run = run,
  step = step,
}
