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
  local opcode = program[instructionPointer] or 0
  local divisor = 10 ^ (param + 1)
  local mode = math.floor(program[instructionPointer] / divisor) % 10
  local address = program[instructionPointer + param]

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
  n = n or 16

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

    local opcode = program[instructionPointer]
    opcode = opcode % 100
    local name = operationNames[opcode] or opcode
    local size = instructionSizes[opcode] or 1
    local params = {}

    for j = 1, size - 1 do
      params[j] = string.format(
        "%16s", formatParam(program, instructionPointer, j))
    end

    print(string.format(
      "%12s:%-3s  %s",
      instructionPointer,
      name,
      table.concat(params, "  ")))

    instructionPointer = instructionPointer + size
  end
end

local function step(program)
  program:step()
  list(program, 1)
end

local function run(program)
  program:run()
  list(program, 1)
end

local function inputQueue(program)
  if program.inputQueue:isEmpty() then
    print("Empty input queue")
    return
  end

  print("Input queue: " .. formatQueue(program.inputQueue))
end

local function loadProgram(filename)
  local source = io.open(filename):read()
  return midwint.Program.new(source)
end

local function outputQueue(program)
  if program.outputQueue:isEmpty() then
    print("Empty output queue")
    return
  end

  print("Output queue: " .. formatQueue(program.outputQueue))
end

local function pushInput(program, value)
  program.inputQueue:push(value)
  inputQueue(program)
end

local function popOutput(program)
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

return {
  inputQueue = inputQueue,
  list = list,
  loadProgram = loadProgram,
  outputQueue = outputQueue,
  popOutput = popOutput,
  pushInput = pushInput,
  run = run,
  step = step,
}
