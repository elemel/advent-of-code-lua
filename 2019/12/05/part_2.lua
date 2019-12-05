local intcode = require("intcode")
local yulea = require("yulea")

local array = yulea.array
local elements = yulea.elements
local map = yulea.map
local split = yulea.split

local program = array(
  map(
    split(io.read(), ","),
    tonumber),
  {},
  0)

intcode.runProgram(0, program, elements({5}), print)
