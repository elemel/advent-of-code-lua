local intcode = {}

local function positionMode(param, memory)
  return memory[param]
end

local function immediateMode(param, memory)
  return param
end

local parameterModes = {
  [0] = positionMode,
  [1] = immediateMode,
}

local function addOperation(ip, memory, inputs, outputs)
  local opMode = memory[ip]

  local aMode = math.floor(opMode / 100) % 10
  local bMode = math.floor(opMode / 1000) % 10

  local a = memory[ip + 1]
  local b = memory[ip + 2]
  local c = memory[ip + 3]

  local aValue = parameterModes[aMode](a, memory)
  local bValue = parameterModes[bMode](b, memory)

  memory[c] = aValue + bValue
  return ip + 4
end

local function multiplyOperation(ip, memory, inputs, outputs)
  local opMode = memory[ip]

  local aMode = math.floor(opMode / 100) % 10
  local bMode = math.floor(opMode / 1000) % 10

  local a = memory[ip + 1]
  local b = memory[ip + 2]
  local c = memory[ip + 3]

  local aValue = parameterModes[aMode](a, memory)
  local bValue = parameterModes[bMode](b, memory)

  memory[c] = aValue * bValue
  return ip + 4
end

local function inputOperation(ip, memory, inputs, outputs)
  local a = memory[ip + 1]
  memory[a] = inputs()
  return ip + 2
end

local function outputOperation(ip, memory, inputs, outputs)
  local opMode = memory[ip]
  local aMode = math.floor(opMode / 100) % 10
  local a = memory[ip + 1]
  local aValue = parameterModes[aMode](a, memory)
  outputs(aValue)
  return ip + 2
end

local function jumpIfTrueOperation(ip, memory, inputs, outputs)
  local opMode = memory[ip]

  local aMode = math.floor(opMode / 100) % 10
  local bMode = math.floor(opMode / 1000) % 10

  local a = memory[ip + 1]
  local b = memory[ip + 2]

  local aValue = parameterModes[aMode](a, memory)
  local bValue = parameterModes[bMode](b, memory)

  return aValue ~= 0 and bValue or ip + 3
end

local function jumpIfFalseOperation(ip, memory, inputs, outputs)
  local opMode = memory[ip]

  local aMode = math.floor(opMode / 100) % 10
  local bMode = math.floor(opMode / 1000) % 10

  local a = memory[ip + 1]
  local b = memory[ip + 2]

  local aValue = parameterModes[aMode](a, memory)
  local bValue = parameterModes[bMode](b, memory)

  return aValue == 0 and bValue or ip + 3
end

local function lessThanOperation(ip, memory, inputs, outputs)
  local opMode = memory[ip]

  local aMode = math.floor(opMode / 100) % 10
  local bMode = math.floor(opMode / 1000) % 10

  local a = memory[ip + 1]
  local b = memory[ip + 2]
  local c = memory[ip + 3]

  local aValue = parameterModes[aMode](a, memory)
  local bValue = parameterModes[bMode](b, memory)

  memory[c] = aValue < bValue and 1 or 0
  return ip + 4
end

local function equalsOperation(ip, memory, inputs, outputs)
  local opMode = memory[ip]

  local aMode = math.floor(opMode / 100) % 10
  local bMode = math.floor(opMode / 1000) % 10

  local a = memory[ip + 1]
  local b = memory[ip + 2]
  local c = memory[ip + 3]

  local aValue = parameterModes[aMode](a, memory)
  local bValue = parameterModes[bMode](b, memory)

  memory[c] = aValue == bValue and 1 or 0
  return ip + 4
end

local function haltOperation(ip, memory, inputs, outputs)
  return nil
end

local operations = {
  [1] = addOperation,
  [2] = multiplyOperation,
  [3] = inputOperation,
  [4] = outputOperation,
  [5] = jumpIfTrueOperation,
  [6] = jumpIfFalseOperation,
  [7] = lessThanOperation,
  [8] = equalsOperation,
  [99] = haltOperation,
}

local function runProgram(ip, memory, inputs, outputs)
  while ip do
    -- print("trace", ip, memory[ip], memory[ip + 1], memory[ip + 2], memory[ip + 3])
    local opcode = memory[ip] % 100
    local operation = assert(operations[opcode], "Invalid opcode")
    ip = operation(ip, memory, inputs, outputs)
  end
end

return {
  runProgram = runProgram,
}
