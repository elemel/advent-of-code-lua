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

  array = yuleaTable.array,
  chars = yuleaString.chars,
  count = yuleaIterator.count,
  cycle = yuleaIterator.cycle,
  digits = yuleaMath.digits,
  elements = yuleaTable.elements,
  findValue = yuleaTable.findValue,
  firstDuplicate = yuleaIterator.firstDuplicate,
  histogram = yuleaTable.histogram,
  isSorted = yuleaTable.isSorted,
  keys = yuleaTable.keys,
  map = yuleaIterator.map,
  maxResult = yuleaMath.maxResult,
  memoize = yuleaTable.memoize,
  permutations = yuleaTable.permutations,
  range = yuleaIterator.range,
  reduce = yuleaIterator.reduce,
  split = yuleaString.split,
  sum = yuleaMath.sum,
}
