local midwint = require("midwint")

local function run(source, noun, verb)
  local program = midwint.Program.new(source)

  program[1] = noun
  program[2] = verb

  program:run()
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
