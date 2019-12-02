local testUtils = require("yulea.test.testUtils")
local yulea = require("yulea")

local deepEquals = testUtils.deepEquals
local enumerate = yulea.iterator.enumerate

local iteratorTest = {}

function iteratorTest.testEnumerate()
  local iterator = enumerate(coroutine.wrap(function()
    coroutine.yield("a")
    coroutine.yield("b")
    coroutine.yield("c")
  end))

  assert(deepEquals({iterator()}, {1, "a"}))
  assert(deepEquals({iterator()}, {2, "b"}))
  assert(deepEquals({iterator()}, {3, "c"}))
  assert(deepEquals({iterator()}, {}))
end

return iteratorTest
