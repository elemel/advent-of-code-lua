local yuleaFunctional = require("yulea.functional")
local yuleaGraph = require("yulea.graph")
local yuleaGrid = require("yulea.grid")
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
  breadthFirstSearch = yuleaGraph.breadthFirstSearch,
  compareDirections = yuleaMath.compareDirections,
  count = yuleaIterator.count,
  cycle = yuleaIterator.cycle,
  depth = yuleaGraph.depth,
  digits = yuleaMath.digits,
  elements = yuleaTable.elements,
  enumerate = yuleaIterator.enumerate,
  factors = yuleaMath.factors,
  findValue = yuleaTable.findValue,
  firstDuplicate = yuleaIterator.firstDuplicate,
  getCell = yuleaGrid.getCell,
  greatestCommonDivisor = yuleaMath.greatestCommonDivisor,
  histogram = yuleaTable.histogram,
  isSorted = yuleaTable.isSorted,
  join = yuleaString.join,
  keys = yuleaTable.keys,
  leastCommonMultiple = yuleaMath.leastCommonMultiple,
  leastCommonMultiple64 = yuleaMath.leastCommonMultiple64,
  map = yuleaIterator.map,
  maxResult = yuleaMath.maxResult,
  memoize = yuleaTable.memoize,
  minResult = yuleaMath.minResult,
  permutations = yuleaTable.permutations,
  printGrid = yuleaGrid.printGrid,
  range = yuleaIterator.range,
  reduce = yuleaIterator.reduce,
  reverse = yuleaTable.reverse,
  setCell = yuleaGrid.setCell,
  setOf = yuleaTable.setOf,
  sign = yuleaMath.sign,
  slice = yuleaTable.slice,
  split = yuleaString.split,
  squaredDistance = yuleaMath.squaredDistance,
  squaredLength = yuleaMath.squaredLength,
  stream = yuleaIterator.stream,
  sum = yuleaMath.sum,
  tableOf = yuleaTable.tableOf,
  toArray = yuleaTable.toArray,
  topologicalSort = yuleaTable.topologicalSort,
  toSet = yuleaTable.toSet,
  toTable = yuleaTable.toTable,
  toTuple = yuleaIterator.toTuple,
  transpose = yuleaMath.transpose,
  values = yuleaTable.values,
}
