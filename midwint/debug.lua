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

local function formatParam(program, instructionPointer, param)
  local opcodeModes = program[instructionPointer] or 0
  local divisor = 10 ^ (param + 1)
  local mode = math.floor(opcodeModes / divisor) % 10
  local address = program[instructionPointer + param]
  local opcode = opcodeModes % 100

  if address == nil then
    return "?"
  end

  if mode == 0 then
    local value = program[address] or "?"
    return address .. ":" .. value
  elseif mode == 1 then
    if opcode == 5 or opcode == 6 then
      address = program.labels[address] or address
    end

    return address
  elseif mode == 2 then
    local value = program[program.relativeBase + address] or "?"
    return program.relativeBase .. "+" .. address .. ":" .. value
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

local function printInstruction(program, instructionPointer)
  local opcode = program[instructionPointer]
  opcode = opcode % 100
  local label = program.labels[instructionPointer] or instructionPointer
  local name = operationNames[opcode] or opcode
  local size = instructionSizes[opcode] or 1
  local params = {}

  if program.breakpoints[instructionPointer] then
    label = "*" .. label
  end

  for j = 1, size - 1 do
    params[j] = string.format(
      "%16s", formatParam(program, instructionPointer, j))
  end

  print(string.format(
    "%12s:%-3s  %s",
    label,
    name,
    table.concat(params, "  ")))

  return size
end

local function list(program, n)
  n = n or 10

  if program:isHalted() then
    print("Program is halted")

    if not program.inputQueue:isEmpty() then
      print("Input queue: " .. formatQueue(program.inputQueue))
    end

    if not program.outputQueue:isEmpty() then
      print("Output queue: " .. formatQueue(program.outputQueue))
    end

    return
  end

  if program:isBlocked() then
    print("Program is blocked")
  end

  local instructionPointer = program.instructionPointer

  for i = 1, n do
    if not program[instructionPointer] then
      break
    end

    local size = printInstruction(program, instructionPointer)
    instructionPointer = instructionPointer + size
  end
end

local function read(program)
  if program.outputQueue:isEmpty() then
    print("Empty output queue")
    return
  end

  local value = program.outputQueue:pop()

  if not program.outputQueue:isEmpty() then
    print("Output queue: " .. formatQueue(program.outputQueue))
  end

  return value
end

local function run(program)
  program:run()
  list(program, 1)
end

local function step(program)
  program:step()
  list(program, 1)
end

local function status(program)
  if program:isHalted() then
    print("Program is halted")
  end

  if program:isBlocked() then
    print("Program is blocked")
  end

  if program.inputQueue:isEmpty() then
    print("Empty input queue")
  else
    print("Input queue: " .. formatQueue(program.inputQueue))
  end

  if program.outputQueue:isEmpty() then
    print("Empty output queue")
  else
    print("Output queue: " .. formatQueue(program.outputQueue))
  end
end

local function write(program, value)
  program.inputQueue:push(value)
  print("Input queue: " .. formatQueue(program.inputQueue))
end

return {
  list = list,
  read = read,
  run = run,
  status = status,
  step = step,
  write = write,
}
