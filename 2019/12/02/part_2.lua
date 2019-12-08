local intcode = require("intcode")

local function run(source, noun, verb)
  local program = intcode.compile(source)

  program[1] = noun
  program[2] = verb

  intcode.run(program)
  return program[0]
end

local source = io.read()

for noun = 0, 99 do
  for verb = 0, 99 do
    local result = run(source, noun, verb)

    if result == 19690720 then
      print(100 * noun + verb)
    end
  end
end
