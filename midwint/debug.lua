local ansicolors = require("midwint.ansicolors")

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

-- See: https://stackoverflow.com/a/49209650
local function stripAnsi(s)
  return string.gsub(s, "[\27\155][][()#;?%d]*[A-PRZcf-ntqry=><~]", "")
end

local function ansiLen(s)
  return #stripAnsi(s)
end

local function leftAlign(s, w)
  local n = ansiLen(s)

  if n >= w then
    return s
  end

  return s .. string.rep(" ", w - n)
end

local function rightAlign(s, w)
  local n = ansiLen(s)

  if n >= w then
    return s
  end

  return string.rep(" ", w - n) .. s
end

local function blue(s)
  return ansicolors("%{blue}" .. s)
end

local function cyan(s)
  return ansicolors("%{cyan}" .. s)
end

local function green(s)
  return ansicolors("%{green}" .. s)
end

local function magenta(s)
  return ansicolors("%{magenta}" .. s)
end

local function red(s)
  return ansicolors("%{red}" .. s)
end

local function yellow(s)
  return ansicolors("%{yellow}" .. s)
end

local function readParam(program, instructionPointer, param)
  local opcode = program[instructionPointer] or 0
  local divisor = 10 ^ (param + 1)
  local mode = math.floor(opcode / divisor) % 10
  local address = program[instructionPointer + param] or 0

  if mode == 0 then
    return program[address] or 0
  elseif mode == 1 then
    return address
  elseif mode == 2 then
    return program[program.relativeBase + address] or 0
  else
    error("Invalid parameter mode")
  end
end

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
    local label = program.labels[address]

    if label then
      return cyan(label) .. ":" .. magenta(value)
    end

    return blue(address) .. ":" .. magenta(value)
  elseif mode == 1 then
    if opcode == 5 or opcode == 6 then
      local label = program.labels[address]

      if label then
        return cyan(label)
      end

      return blue(address)
    end

    return magenta(address)
  elseif mode == 2 then
    local value = program[program.relativeBase + address] or "?"
    return cyan("rb") .. blue(string.format("%+d", address)) .. ":" .. magenta(value)
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

  local label = program.labels[instructionPointer]

  if label then
    label = cyan(label)
  else
    label = blue(instructionPointer)
  end

  local name = operationNames[opcode]

  if name then
    if name == "hcf" then
      name = red(name)
    elseif name == "in" then
      if program.inputQueue:isEmpty() then
        name = red(name)
      else
        name = yellow(name)
      end
    elseif name == "jif" then
      local value = readParam(program, instructionPointer, 1)

      if value == 0 then
        name = green(name)
      else
        name = yellow(name)
      end
    elseif name == "jit" then
      local value = readParam(program, instructionPointer, 1)

      if value ~= 0 then
        name = green(name)
      else
        name = yellow(name)
      end
    else
      name = yellow(name)
    end
  else
    name = opcode
  end

  local size = instructionSizes[opcode] or 1
  local params = {}

  if program.breakpoints[instructionPointer] then
    label = yellow("*") .. label
  end

  for j = 1, size - 1 do
    params[j] = rightAlign(formatParam(program, instructionPointer, j), 16)
  end

  print(string.format(
    "%s:%s  %s",
    rightAlign(label, 12),
    leftAlign(name, 3),
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

local function scan(program)
  local j

  for i = 0, #program do
    if program[i] == 109 then
      if (program[i + 1] or 0) > 0 then
        j = i
      else
        if j and (program[i + 1]  or 0) == -program[j + 1] and program[i + 2] == 2105 and program[i + 3] == 1 and program[i + 4] == 0 then
          print("Function at " .. j .. "-" .. i + 2)
          program.labels[j] = "func" .. j
        else
          j = nil
        end
      end
    end
  end
end

return {
  list = list,
  read = read,
  run = run,
  scan = scan,
  status = status,
  step = step,
  write = write,
}
