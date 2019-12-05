local intcode = require("intcode")
local yulea = require("yulea")

local array = yulea.array
local elements = yulea.elements
local map = yulea.map
local split = yulea.split

local program = intcode.compile(io.read())
intcode.run(program, 0, elements({1}))
