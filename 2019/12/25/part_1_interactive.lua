local intcode = require("intcode")
local yulea = require("yulea")

local program = intcode.Program.new(io.open("2019/12/25/input.txt"):read())
local row = {}

repeat
  program:run()

  while program:canRead() do
    local output = program:read()

    if output >= 256 then
      print(output)
    else
      if output == string.byte("\n") then
        print(table.concat(row))
        row = {}
      else
        row[#row + 1] = string.char(output)
      end
    end
  end

  program:writeLine(io.read())
until program:isHalted()
