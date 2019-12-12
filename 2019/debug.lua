midwint = require("midwint")

list = midwint.debug.list
read = midwint.debug.read
run = midwint.debug.run
scan = midwint.debug.scan
status = midwint.debug.status
step = midwint.debug.step
write = midwint.debug.write

function day(n)
  local filename = string.format("2019/12/%02d/input.txt", n)
  local source = io.open(filename):read()
  return midwint.Program.new(source)
end

function day2()
  return day(2)
end

function day5()
  return day(5)
end

function day7()
  return day(7)
end

function day9()
  return day(9)
end

function day11()
  return day(11)
end
