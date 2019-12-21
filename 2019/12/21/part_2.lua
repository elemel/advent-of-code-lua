local midwint = require("midwint")
local yulea = require("yulea")

local split = yulea.split

local function writeLine(program, line)
  for char in split(line) do
    program.inputQueue:push(string.byte(char))
  end

  program.inputQueue:push(10)
end

local function printVideo(program)
  local row = {}

  while not program.outputQueue:isEmpty() do
    local output = program.outputQueue:pop()

    if output >= 256 then
      return output
    end

    if output == string.byte("\n") then
      -- print(table.concat(row))
      row = {}
    else
      row[#row + 1] = string.char(output)
    end
  end

  return nil
end

local program = midwint.Program.new(io.read())

writeLine(program, "NOT A J")

writeLine(program, "NOT B T")
writeLine(program, "OR T J")

writeLine(program, "NOT C T")
writeLine(program, "AND H T")
writeLine(program, "OR T J")

writeLine(program, "AND D J")
writeLine(program, "RUN")
program:run()

print(printVideo(program) or "X")
