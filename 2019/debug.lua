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

function day13()
  local program = day(13)

  for i = 379, 392 do
    program.data[i] = true
  end

  for i = 639, #program do
    program.data[i] = true
  end

  scan(program)
  return program
end

function day15()
  local program = day(15)
  scan(program)
  return program
end

function day17()
  local program = day(15)

  for i = 252, 1044 do
    program.data[i] = true
  end

  scan(program)
  return program
end

function day25()
  local program = day(25)

  for i = 43, 1129 do
    program.data[i] = true
  end

  for i = 1894, 1946 do
    program.data[i] = true
  end

  for i = 2963, 3009 do
    program.data[i] = true
  end

  for i = 3094, 4817 do
    program.data[i] = true
  end

  scan(program)
  return program
end
