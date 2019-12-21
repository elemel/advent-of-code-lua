local midwint = require("midwint")
local yulea = require("yulea")

local split = yulea.split

local function writeLine(program, line)
  for char in split(line) do
    program.inputQueue:push(string.byte(char))
  end

  program.inputQueue:push(10)
end

local program = midwint.Program.new(io.read())

writeLine(program, "NOT J J")
writeLine(program, "AND A J")
writeLine(program, "AND B J")
writeLine(program, "AND C J")
writeLine(program, "NOT J J")
writeLine(program, "AND D J")
writeLine(program, "WALK")

program:run()
local row = {}

while not program.outputQueue:isEmpty() do
  local output = program.outputQueue:pop()

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
