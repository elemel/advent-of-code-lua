local intcode = require("intcode")
local yulea = require("yulea")

local array = yulea.array
local elements = yulea.elements
local map = yulea.map
local split = yulea.split

local program = intcode.compile(io.read())
program.inputs:push_right(1)
intcode.run(program)

while not program.outputs:is_empty() do
  print(program.outputs:pop_left())
end
