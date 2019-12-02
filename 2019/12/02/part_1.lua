local yulea = require("yulea")

local array = yulea.table.array
local map = yulea.iterator.map
local split = yulea.string.split

local program = array(
  map(
    split(io.read("*line"), ","),
    tonumber),
  {}, 0)

program[1] = 12
program[2] = 2

local ip = 0

while program[ip] ~= 99 do
  if program[ip] == 1 then
    local param1 = program[ip + 1]
    local param2 = program[ip + 2]
    local param3 = program[ip + 3]

    program[param3] = program[param1] + program[param2]
    ip = ip + 4
  elseif program[ip] == 2 then
    local param1 = program[ip + 1]
    local param2 = program[ip + 2]
    local param3 = program[ip + 3]

    program[param3] = program[param1] * program[param2]
    ip = ip + 4
  end
end

print(program[0])
