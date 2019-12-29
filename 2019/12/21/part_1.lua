local intcode = require("intcode")
local yulea = require("yulea")

local program = intcode.Program.new(io.read())

program:writeLine("NOT J J")
program:writeLine("AND A J")
program:writeLine("AND B J")
program:writeLine("AND C J")
program:writeLine("NOT J J")
program:writeLine("AND D J")
program:writeLine("WALK")

program:run()
local row = {}

while program:canRead() do
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
