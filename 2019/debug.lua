midwint = require("midwint")

list = midwint.debug.list
read = midwint.debug.read
run = midwint.debug.run
status = midwint.debug.status
step = midwint.debug.step
write = midwint.debug.write

function newProgram9()
  local filename = string.format("2019/12/09/input.txt")
  local source = io.open(filename):read()
  local program = midwint.Program.new(source)
  program.labels[53] = "fail1"
  return program
end
