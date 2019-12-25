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
    return s, n
  end

  return s .. string.rep(" ", w - n), w
end

local function rightAlign(s, w)
  local n = ansiLen(s)

  if n >= w then
    return s, n
  end

  return string.rep(" ", w - n) .. s, w
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

local function formatColumns(columns, columnWidth)
  columnWidth = columnWidth or 16

  local buffer = {}
  local totalWidth = 0
  local targetWidth = 0

  for i, column in ipairs(columns) do
    local width = ansiLen(column)

    if i == 1 then
      targetWidth = columnWidth
      paddingWidth = math.max(0, targetWidth - width)
      totalWidth = paddingWidth + width

      table.insert(buffer, string.rep(" ", paddingWidth))
      table.insert(buffer, column)
    else
      targetWidth = targetWidth + 2 + columnWidth
      paddingWidth = math.max(0, targetWidth - totalWidth - width - 2)
      totalWidth = totalWidth + 2 + paddingWidth + width

      table.insert(buffer, " ")
      table.insert(buffer, string.rep(".", paddingWidth))
      table.insert(buffer, " ")
      table.insert(buffer, column)
    end
  end

  return table.concat(buffer)
end

local function readParameter(program, instructionPointer, parameter)
  local opcode = program.memory[instructionPointer] or 0
  local divisor = 10 ^ (parameter + 1)
  local mode = math.floor(opcode / divisor) % 10
  local address = program.memory[instructionPointer + parameter] or 0

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

local function formatParameter(program, instructionPointer, parameter)
  local opcodeModes = program.memory[instructionPointer] or 0
  local divisor = 10 ^ (parameter + 1)
  local mode = math.floor(opcodeModes / divisor) % 10
  local address = program.memory[instructionPointer + parameter]
  local opcode = opcodeModes % 100

  if address == nil then
    return "?"
  end

  if mode == 0 then
    local value = program.memory[address] or "?"
    local label = program.labels[address]

    if label then
      return cyan(label) .. ":" .. magenta(value)
    end

    return blue(address) .. ":" .. magenta(value)
  elseif mode == 1 then
    if (opcode == 5 or opcode == 6) and parameter == 2 then
      local label = program.labels[address]

      if label then
        return cyan(label)
      end

      return blue(address)
    end

    return magenta(address)
  elseif mode == 2 then
    local value = program.memory[program.relativeBase + address] or "?"
    return cyan("rb") .. blue(string.format("%+d", address)) .. ":" .. magenta(value)
  else
    return "?"
  end
end

local function queueElements(queue)
  local t = {}

  for i = queue.first, queue.last do
    t[#t + 1] = queue[i]
  end

  return t
end

local function formatQueue(queue)
  return table.concat(queueElements(queue), ", ")
end

local function printInstruction(program, instructionPointer)
  local opcode = program.memory[instructionPointer]
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
      local value = readParameter(program, instructionPointer, 1)

      if value == 0 then
        name = green(name)
      else
        name = yellow(name)
      end
    elseif name == "jit" then
      local value = readParameter(program, instructionPointer, 1)

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
  local parameters = {}

  if program.breakpoints[instructionPointer] then
    label = yellow("*") .. label
  end

  columns = {}
  table.insert(columns, label .. ":" .. leftAlign(name, 2))

  for j = 1, size - 1 do
    table.insert(columns, formatParameter(program, instructionPointer, j))
  end

  print(formatColumns(columns, 16))
  return size
end

local function formatWatchQueue(queue)
  local elements = queueElements(queue)
  local t = {}

  for i, element in ipairs(elements) do
    t[i] = magenta(element)
  end

  return "{" .. table.concat(t, ",") .. "}"
end

local function formatWatch(watch, program)
  if watch == "ip" then
    local value = program.instructionPointer or "?"
    return cyan("ip") .. "=" .. magenta(value)
  elseif watch == "rb" then
    local value = program.relativeBase or "?"
    return cyan("rb") .. "=" .. magenta(value)
  elseif watch == "iq" then
    return cyan("iq") .. "=" .. formatWatchQueue(program.inputQueue)
  elseif watch == "oq" then
    return cyan("oq") .. "=" .. formatWatchQueue(program.outputQueue)
  else
    local value = program.memory[watch] or "?"
    return blue(watch) .. ":" .. magenta(value)
  end
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
    if not program.memory[instructionPointer] then
      break
    end

    if program.data[instructionPointer] then
      local value = program.memory[instructionPointer]
      local line = instructionPointer .. ":" .. value

      if value >= 32 and value <= 126 then
        line = line .. "\t\t" .. string.char(value)
      end

      print(line)
      instructionPointer = instructionPointer + 1
    else
      local size = printInstruction(program, instructionPointer)
      instructionPointer = instructionPointer + size
    end
  end

  print("Watches:")
  local watches = {}

  for i, watch in ipairs(program.watches) do
    table.insert(watches, formatWatch(watch, program))
  end

  for i = 1, math.ceil(#watches / 4) do
    local columns = {}

    for j = i * 4 - 3, math.min(i * 4, #watches) do
      table.insert(columns, watches[j])
    end

    print(formatColumns(columns, 16))
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
  local instructions = {}
  local parameters = {}
  local reads = {}
  local writes = {}
  local targets = {}
  local functions = {}

  local func

  for i = 0, #program do
    if not program.data[i] and not parameters[i] then
      local opcodeModes = program.memory[i]
      local opcode = opcodeModes % 100

      local mode1 = math.floor(opcodeModes / 100) % 10
      local mode2 = math.floor(opcodeModes / 1000) % 10
      local mode3 = math.floor(opcodeModes / 10000) % 10

      if opcode == 9 and mode1 == 1 then
        if (program.memory[i + 1] or 0) > 0 then
          func = i
        else
          if (func and
            (program.memory[i + 1]  or 0) == -program.memory[func + 1] and
            program.memory[i + 2] == 2105 and program.memory[i + 3] == 1 and
            program.memory[i + 4] == 0) then

            functions[func] = i + 2
          elseif (func and
            (program.memory[i + 1]  or 0) == -program.memory[func + 1] and
            program.memory[i + 2] == 2106 and program.memory[i + 3] == 0 and
            program.memory[i + 4] == 0) then

            functions[func] = i + 2
          else
            func = nil
          end
        end
      end

      if instructionSizes[opcode] then
        instructions[i] = true

        for j = 1, instructionSizes[opcode] - 1 do
          parameters[i + j] = true
        end
      end

      if ((opcode == 1 or opcode == 2 or opcode == 4 or opcode == 5 or
        opcode == 6 or opcode == 7 or opcode == 8 or opcode == 9) and
        mode1 == 0) then

        local var = program.memory[i + 1] or 0
        reads[var] = true
      end

      if ((opcode == 1 or opcode == 2 or opcode == 7 or opcode == 8) and
        mode2 == 0)
      then

        local var = program.memory[i + 2] or 0
        reads[var] = true
      end

      if ((opcode == 1 or opcode == 2 or opcode == 7 or opcode == 8) and
        mode3 == 0) then

        local var = program.memory[i + 3] or 0
        writes[var] = true
      end

      if opcode == 3 and mode1 == 0 then
        local var = program.memory[i + 1] or 0
        writes[var] = true
      end

      if (opcode == 5 or opcode == 6) and mode2 == 1 then
        local target = program.memory[i + 2] or 0
        targets[target] = true
      end
    end
  end

  for i = 0, #program do
    if not program.labels[i] then
      if functions[i] then
        program.labels[i] = "f" .. i
      elseif targets[i] then
        program.labels[i] = "t" .. i
      -- elseif instructions[i] then
        -- program.labels[i] = "i" .. i
      elseif writes[i] then
        program.labels[i] = "w" .. i
      elseif reads[i] then
        program.labels[i] = "r" .. i
      end

      if program.labels[i] then
        print(program.labels[i])
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
