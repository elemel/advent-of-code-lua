local function read(memory, ip, param)
  local divisor = 10 * 10 ^ param
  local mode = math.floor(memory[ip] / divisor) % 10
  local address = memory[ip + param]
  return mode == 0 and memory[address] or address
end

local function write(memory, ip, param, value)
  local address = memory[ip + param]
  memory[address] = value
end

local function add(memory, ip, inputs, outputs)
  local left = read(memory, ip, 1)
  local right = read(memory, ip, 2)
  local result = left + right
  write(memory, ip, 3, result)
  return ip + 4
end

local function multiply(memory, ip, inputs, outputs)
  local left = read(memory, ip, 1)
  local right = read(memory, ip, 2)
  local result = left * right
  write(memory, ip, 3, result)
  return ip + 4
end

local function input(memory, ip, inputs, outputs)
  local result = inputs()
  write(memory, ip, 1, result)
  return ip + 2
end

local function output(memory, ip, inputs, outputs)
  local result = read(memory, ip, 1)
  outputs(result)
  return ip + 2
end

local function jumpIfTrue(memory, ip, inputs, outputs)
  local value = read(memory, ip, 1)
  local address = read(memory, ip, 2)
  return value ~= 0 and address or ip + 3
end

local function jumpIfFalse(memory, ip, inputs, outputs)
  local value = read(memory, ip, 1)
  local address = read(memory, ip, 2)
  return value == 0 and address or ip + 3
end

local function lessThan(memory, ip, inputs, outputs)
  local left = read(memory, ip, 1)
  local right = read(memory, ip, 2)
  local result = left < right and 1 or 0
  write(memory, ip, 3, result)
  return ip + 4
end

local function equals(memory, ip, inputs, outputs)
  local left = read(memory, ip, 1)
  local right = read(memory, ip, 2)
  local result = left == right and 1 or 0
  write(memory, ip, 3, result)
  return ip + 4
end

local function halt(memory, ip, inputs, outputs)
  return nil
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

local function compile(line)
  local program = {}
  local address = 0

  for s in string.gmatch(line, "-?%d+") do
    program[address] = tonumber(s)
    address = address + 1
  end

  return program
end

local function run(memory, ip, inputs, outputs)
  ip = ip or 0

  inputs = inputs or function()
    return io.read("*number")
  end

  outputs = outputs or print

  while ip do
    local opcode = memory[ip] % 100
    local operation = assert(operations[opcode], "Invalid opcode")
    ip = operation(memory, ip, inputs, outputs)
  end
end

return {
  compile = compile,
  run = run,
}
