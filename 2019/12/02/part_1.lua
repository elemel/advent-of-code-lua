local yulea = require("yulea")

local array = yulea.table.array
local map = yulea.iterator.map
local split = yulea.string.split

local program = array(
  map(
    split(io.read(), ","),
    tonumber),
  {}, 0)

program[1] = 12
program[2] = 2

local ip = 0

while program[ip] ~= 99 do
  if program[ip] == 1 then
    local a = program[ip + 1]
    local b = program[ip + 2]
    local c = program[ip + 3]

    program[c] = program[a] + program[b]
    ip = ip + 4
  elseif program[ip] == 2 then
    local a = program[ip + 1]
    local b = program[ip + 2]
    local c = program[ip + 3]

    program[c] = program[a] * program[b]
    ip = ip + 4
  end
end

print(program[0])
