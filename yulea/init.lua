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

  all = yuleaMath.all,
  any = yuleaMath.any,
  array = yuleaTable.array,
  compareDirections = yuleaMath.compareDirections,
  count = yuleaIterator.count,
  cycle = yuleaIterator.cycle,
  digits = yuleaMath.digits,
  elements = yuleaTable.elements,
  enumerate = yuleaIterator.enumerate,
  findValue = yuleaTable.findValue,
  firstDuplicate = yuleaIterator.firstDuplicate,
  greatestCommonDivisor = yuleaMath.greatestCommonDivisor,
  histogram = yuleaTable.histogram,
  isSorted = yuleaTable.isSorted,
  join = yuleaString.join,
  keys = yuleaTable.keys,
  leastCommonMultiple = yuleaMath.leastCommonMultiple,
  map = yuleaIterator.map,
  maxResult = yuleaMath.maxResult,
  memoize = yuleaTable.memoize,
  permutations = yuleaTable.permutations,
  range = yuleaIterator.range,
  reduce = yuleaIterator.reduce,
  split = yuleaString.split,
  squaredDistance = yuleaMath.squaredDistance,
  squaredLength = yuleaMath.squaredLength,
  stream = yuleaIterator.stream,
  sum = yuleaMath.sum,
  toTuple = yuleaIterator.toTuple,
  transpose = yuleaMath.transpose,
}
