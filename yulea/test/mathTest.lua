local yulea = require("yulea")

local accumulate = yulea.math.accumulate
local maxResult = yulea.math.maxResult
local minResult = yulea.math.minResult
local sum = yulea.math.sum

local mathTest = {}

function mathTest.testAccumulate()
  local iterator = accumulate(coroutine.wrap(function()
    coroutine.yield(1)
    coroutine.yield(2)
    coroutine.yield(3)
  end))

  assert(iterator() == 1)
  assert(iterator() == 3)
  assert(iterator() == 6)
  assert(iterator() == nil)
end

function mathTest.testMaxResult()
  local iterator = coroutine.wrap(function()
    coroutine.yield(1)
    coroutine.yield(2)
    coroutine.yield(3)
  end)

  assert(maxResult(iterator) == 3)
end

function mathTest.testMinResult()
  local iterator = coroutine.wrap(function()
    coroutine.yield(1)
    coroutine.yield(2)
    coroutine.yield(3)
  end)

  assert(minResult(iterator) == 1)
end

function mathTest.testSum()
  local iterator = coroutine.wrap(function()
    coroutine.yield(1)
    coroutine.yield(2)
    coroutine.yield(3)
  end)

  assert(sum(iterator) == 6)
end

return mathTest
