local midwint = require("midwint")

local function run(source, noun, verb)
  local program = midwint.Program.new(source)

  program.memory[1] = noun
  program.memory[2] = verb

  program:run()
  return program.memory[0]
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
