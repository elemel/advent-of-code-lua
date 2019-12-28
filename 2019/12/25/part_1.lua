local intcode = require("intcode")
local yulea = require("yulea")

local band = bit.band
local lshift = bit.lshift
local split = yulea.split

local program = intcode.Program.new(io.read())

local function readLine(program)
  local chars = {}

  while not program.outputQueue:is_empty() do
    local output = program.outputQueue:pop_left()

    if output == string.byte("\n") then
      local line = table.concat(chars)
      chars = {}
      return line
    else
      chars[#chars + 1] = string.char(output)
    end
  end

  assert(#chars == 0)
  return nil
end

local function writeLine(program, line)
  for char in split(line) do
    program.inputQueue:push_right(string.byte(char))
  end

  program.inputQueue:push_right(10)
end

local function printOutput(program)
  while true do
    local line = readLine(program)

    if line == nil then
      return
    end

    print(line)
  end
end

local function runCommand(program, command)
  writeLine(program, command)
  program:run()
  printOutput(program)
end

local commands = {
  "west",
  "south",
  "east",
  "south",
  "north",
  "west",
  "south",
  "south",
  "take asterisk",
  "north",
  "north",
  "north",
  "west",
  "south",
  "take astronaut ice cream",
  "south",
  "take polygon",
  "east",
  "take easter egg",
  "north",
  "south",
  "east",
  "take weather machine",
  "north",
  "south",
  "west",
  "west",
  "north",
  "west",
  "east",
  "north",
  "west",
  "south",
  "take fixed point",
  "west",
  "take food ration",
  "east",
  "north",
  "west",
  "take dark matter",
  "east",
  "east",
  "east",
  "east",

  "west",
  "west",
  "south",
  "south",
  "east",
  "east",
  "north",
}

program:run()
printOutput(program)

for _, command in ipairs(commands) do
  runCommand(program, command)
end

local items = {
  "asterisk",
  "astronaut ice cream",
  "polygon",
  "easter egg",
  "weather machine",
  "fixed point",
  "food ration",
  "dark matter",
}

for _, item in ipairs(items) do
  runCommand(program, "drop " .. item)
end

for i = 0, 255 do
  for j = 0, 7 do
    if band(lshift(1, j), i) ~= 0 then
      runCommand(program, "take " .. items[j + 1])
    end
  end

  runCommand(program, "north")

  for j = 0, 7 do
    if band(lshift(1, j), i) ~= 0 then
      runCommand(program, "drop " .. items[j + 1])
    end
  end
end
