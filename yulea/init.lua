local yuleaFunctional = require("yulea.functional")
local yuleaIo = require("yulea.io")
local yuleaIterator = require("yulea.iterator")
local yuleaMath = require("yulea.math")
local yuleaString = require("yulea.string")
local yuleaTable = require("yulea.table")

return {
  functional = yuleaFunctional,
  io = yuleaIo,
  iterator = yuleaIterator,
  math = yuleaMath,
  string = yuleaString,
  table = yuleaTable,

  count = yuleaIterator.count,
  digits = yuleaMath.digits,
  elements = yuleaTable.elements,
  findValue = yuleaTable.findValue,
  firstDuplicate = yuleaIterator.firstDuplicate,
  histogram = yuleaTable.histogram,
  isSorted = yuleaTable.isSorted,
  range = yuleaIterator.range,
}
