local yulea = require("yulea")

local array = yulea.table.array
local copy = yulea.table.copy
local elements = yulea.table.elements
local map = yulea.iterator.map
local split = yulea.string.split

local function run(program, noun, verb)
  local memory = copy(program)

  memory[1] = noun
  memory[2] = verb

  local ip = 0

  while true do
    local opcode = memory[ip]

    if opcode == 99 then
      return memory[0]
    end

    if opcode == 1 then
      local param1 = memory[ip + 1]
      local param2 = memory[ip + 2]
      local param3 = memory[ip + 3]

      memory[param3] = memory[param1] + memory[param2]
      ip = ip + 4
    elseif opcode == 2 then
      local param1 = memory[ip + 1]
      local param2 = memory[ip + 2]
      local param3 = memory[ip + 3]

      memory[param3] = memory[param1] * memory[param2]
      ip = ip + 4
    end
  end
end

local program = array(map(split(io.read("*line"), ","), tonumber), {}, 0)

for noun = 0, 99 do
  for verb = 0, 99 do
    local result = run(program, noun, verb)

    if result == 19690720 then
      print(100 * noun + verb)
    end
  end
end
