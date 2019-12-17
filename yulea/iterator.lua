local Stream = require("yulea.Stream")

local unpack = unpack or table.unpack

local function count(iterator)
  local result = 0

  for _ in iterator do
    result = result + 1
  end

  return result
end

local function cycle(iterator, n)
  n = n or math.huge

  return coroutine.wrap(function()
    local elements = {}

    for element in iterator do
      coroutine.yield(element)
      table.insert(elements, element)
    end

    for _ = 2, n do
      for _, element in ipairs(elements) do
        coroutine.yield(element)
      end
    end
  end)
end

local function distinct(iterator)
  return coroutine.wrap(function()
    local seen = {}

    for element in iterator do
      if not seen[element] then
        coroutine.yield(element)
        seen[element] = true
      end
    end
  end)
end

local function enumerate(iterator, first, last, step)
  first = first or 1
  last = last or math.huge
  step = step or 1

  return coroutine.wrap(function()
    for i = first, last, step do
      local element = iterator()

      if element == nil then
        break
      end

      coroutine.yield(i, element)
    end
  end)
end

local function enumerateTuple(iterator, first, last, step)
  first = first or 1
  last = last or math.huge
  step = step or 1

  return coroutine.wrap(function()
    for i = first, last, step do
      local elements = {iterator()}

      if #elements == 0 then
        break
      end

      coroutine.yield(i, unpack(elements))
    end
  end)
end

local function filter(iterator, predicate)
  return coroutine.wrap(function()
    for element in iterator do
      if predicate(element) then
        coroutine.yield(element)
      end
    end
  end)
end

local function firstDuplicate(iterator)
  local seen = {}

  for element in iterator do
    if seen[element] then
      return element
    end

    seen[element] = true
  end

  return nil
end

local function flatMap(iterator, mapper)
  return coroutine.wrap(function()
    for element in iterator do
      for _, result in ipairs({mapper(element)}) do
        coroutine.yield(result)
      end
    end
  end)
end

local function map(iterator, mapper)
  return coroutine.wrap(function()
    for element in iterator do
      coroutine.yield(mapper(element))
    end
  end)
end

local function range(first, last, step)
  first = first or 1
  last = last or math.huge
  step = step or 1

  return coroutine.wrap(function()
    for i = first, last, step do
      coroutine.yield(i)
    end
  end)
end

local function reduce(iterator, reducer, init)
  local result = init or iterator()

  if result ~= nil then
    for element in iterator do
      result = reducer(result, element)
    end
  end

  return result
end

local function rep(v, n)
  n = n or math.huge

  return coroutine.wrap(function()
    for i = 1, n do
      coroutine.yield(v)
    end
  end)
end

local function stream(iterator)
  return Stream.new(iterator)
end

local function take(iterator, n)
  return coroutine.wrap(function()
    for i = 1, n do
      coroutine.yield(iterator())
    end
  end)
end

local function toTuple(iterator)
  local t = {}

  for element in iterator do
    t[#t + 1] = element
  end

  return unpack(t)
end

return {
  count = count,
  cycle = cycle,
  distinct = distinct,
  enumerate = enumerate,
  enumerateTuple = enumerateTuple,
  filter = filter,
  firstDuplicate = firstDuplicate,
  flatMap = flatMap,
  map = map,
  range = range,
  reduce = reduce,
  rep = rep,
  stream = stream,
  take = take,
  toTuple = toTuple,
}
