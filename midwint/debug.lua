local operationNames = {
  [1] = "add",
  [2] = "mul",
  [3] = "in",
  [4] = "out",
  [5] = "jit",
  [6] = "jif",
  [7] = "lt",
  [8] = "eq",
  [9] = "arb",
  [99] = "hcf",
}

local operationSizes = {
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

local function formatParam(program, ip, param)
  local divisor = 10 ^ (param + 1)
  local mode = math.floor(program[ip] / divisor) % 10
  local address = program[ip + param]

  if address == nil then
    return "?"
  end

  if mode == 0 then
    local value = program[address] or "?"
    return address .. ":" .. value
  elseif mode == 1 then
    return address
  elseif mode == 2 then
    local value = program[address + program.relativeBase] or "?"
    return address .. "+" .. program.relativeBase .. ":" .. value
  else
    return "?"
  end
end

local function formatQueue(queue)
  local t = {}

  for i = queue.first, queue.last do
    t[#t + 1] = queue[i]
  end

  return table.concat(t, ", ")
end

local function list(program, n)
  n = n or 1

  if not program.ip then
    print("Program is halted")

    if not program.outputs:isEmpty() then
      print("Output queue: " .. formatQueue(program.outputs))
    end

    return
  end

  local opcode = program[program.ip] % 100

  if opcode == 3 and program.inputs:isEmpty() then
    print("Empty input queue")
  end

  local ip = program.ip

  for i = 1, n do
    if not program[ip] then
      break
    end

    local opcode = program[ip] % 100

    local name = operationNames[opcode] or opcode
    local size = operationSizes[opcode] or 1
    local params = {}

    for j = 1, size - 1 do
      params[j] = string.format("%-16s", formatParam(program, ip, j))
    end

    print(string.format("%-16s%-16s%s", ip, name, table.concat(params)))
    ip = ip + size
  end
end

local function step(program)
  program:step()
  list(program)
end

local function run(program)
  program:run()
  list(program)
end

local function inputs(program)
  if program.inputs:isEmpty() then
    print("Empty input queue")
    return
  end

  print("Input queue: " .. formatQueue(program.inputs))
end

local function outputs(program)
  if program.outputs:isEmpty() then
    print("Empty output queue")
    return
  end

  print("Output queue: " .. formatQueue(program.outputs))
end

local function pushInput(program, value)
  program.inputs:push(value)
  inputs(program)
end

local function popOutput(program)
  if program.outputs:isEmpty() then
    print("Empty output queue")
    return
  end

  return program.outputs:pop()
end

return {
  inputs = inputs,
  list = list,
  outputs = outputs,
  popOutput = popOutput,
  pushInput = pushInput,
  run = run,
  step = step,
}
