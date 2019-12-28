local intcode = require("intcode")
local yulea = require("yulea")

local split = yulea.split

local program = intcode.Program.new(io.open("2019/12/25/input.txt"):read())

local function writeLine(program, line)
  for char in split(line) do
    program.inputQueue:push_right(string.byte(char))
  end

  program.inputQueue:push_right(10)
end

local row = {}

repeat
  program:run()

  while not program.outputQueue:is_empty() do
    local output = program.outputQueue:pop_left()

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

  writeLine(program, io.read())
until program:isHalted()
