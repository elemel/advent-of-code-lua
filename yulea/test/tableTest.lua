local yulea = require("yulea")
local testUtils = require("yulea.test.testUtils")

local array = yulea.table.array
local compare = yulea.table.compare
local deepEquals = testUtils.deepEquals

local tableTest = {}

function tableTest.testArray()
  local iterator = coroutine.wrap(function()
    coroutine.yield(1)
    coroutine.yield(2)
    coroutine.yield(3)
  end)

  assert(deepEquals(array(iterator), {1, 2, 3}))
end

function tableTest.testCompare()
  assert(not compare({}, {}))
  assert(compare({}, {1}))
  assert(not compare({1}, {}))
  assert(not compare({1}, {1}))
  assert(compare({1}, {2}))
  assert(not compare({2}, {1}))
  assert(not compare({1, 2}, {1, 2}))
  assert(compare({1, 2}, {1, 3}))
  assert(compare({1, 2}, {1, 2, 3}))
  assert(not compare({1, 2, 3}, {1, 2}))
end

return tableTest
