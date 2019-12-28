intcode = require("intcode")

list = intcode.debug.list
read = intcode.debug.read
run = intcode.debug.run
scan = intcode.debug.scan
status = intcode.debug.status
step = intcode.debug.step
write = intcode.debug.write

function day(n)
  local filename = string.format("2019/12/%02d/input.txt", n)
  local source = io.open(filename):read()
  return intcode.Program.new(source)
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

  for i = 34, 1129 do
    program.data[i] = true
  end

  for i = 1308, 1309 do
    program.data[i] = true
  end

  for i = 1352, 1352 do
    program.data[i] = true
  end

  for i = 1550, 1552 do
    program.data[i] = true
  end

  for i = 1894, 1983 do
    program.data[i] = true
  end

  for i = 2124, 2124 do
    program.data[i] = true
  end

  for i = 2280, 2280 do
    program.data[i] = true
  end

  for i = 2486, 2486 do
    program.data[i] = true
  end

  for i = 2523, 2524 do
    program.data[i] = true
  end

  for i = 2721, 2721 do
    program.data[i] = true
  end

  for i = 2959, 3009 do
    program.data[i] = true
  end

  for i = 3094, 4817 do
    program.data[i] = true
  end

  scan(program)
  return program
end
