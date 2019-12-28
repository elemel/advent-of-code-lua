local intcode = require("intcode")
local yulea = require("yulea")

local split = yulea.split

local function writeLine(program, line)
  for char in split(line) do
    program:write(string.byte(char))
  end

  program:write(10)
end

local program = intcode.Program.new(io.read())

writeLine(program, "NOT H J")
writeLine(program, "OR C J")
writeLine(program, "AND A J")
writeLine(program, "AND B J")
writeLine(program, "NOT J J")
writeLine(program, "AND D J")
writeLine(program, "RUN")

program:run()
local row = {}

while not program.outputQueue:is_empty() do
  local output = program:read()

  if output >= 256 then
    print(output)
  else
    if output == string.byte("\n") then
      -- print(table.concat(row))
      row = {}
    else
      row[#row + 1] = string.char(output)
    end
  end
end
