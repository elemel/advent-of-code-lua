local function readNumber()
  return io.read("*number")
end

local function read(program, param)
  local divisor = 10 * 10 ^ param
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
  local result = program.inputs()
  write(program, 1, result)
  program.ip = program.ip + 2
end

local function output(program)
  local result = read(program, 1)
  program.outputs(result)
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
  assert(program.ip, "Invalid instruction pointer")
  local opcode = program[program.ip] % 100
  local operation = assert(operations[opcode], "Invalid opcode")
  operation(program)
end

local function run(program)
  while program.ip do
    step(program)
  end
end

local function load(line)
  local program = {}
  local address = 0

  for s in string.gmatch(line, "-?%d+") do
    program[address] = tonumber(s)
    address = address + 1
  end

  program.ip = 0
  program.inputs = readNumber
  program.outputs = print

  program.step = step
  program.run = run

  return program
end

return {
  load = load,
  run = run,
  step = step,
}
