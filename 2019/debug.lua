midwint = require("midwint")

list = midwint.debug.list
read = midwint.debug.read
run = midwint.debug.run
status = midwint.debug.status
step = midwint.debug.step
write = midwint.debug.write

function day(i)
  local filename = string.format("2019/12/%02d/input.txt", i)
  local source = io.open(filename):read()
  return midwint.Program.new(source)
end
