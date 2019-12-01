local function cycle(iterator)
  return coroutine.wrap(function()
    local elements = {}

    for element in iterator do
      coroutine.yield(element)
      table.insert(elements, element)
    end

    while true do
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

local function enumerate(iterator, index)
  index = index or 1

  return coroutine.wrap(function()
    for element in iterator do
      coroutine.yield(index, element)
      index = index + 1
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

local function reduce(iterator, reducer)
  local result = iterator()

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

local function take(iterator, n)
  return coroutine.wrap(function()
    for i = 1, n do
      coroutine.yield(iterator())
    end
  end)
end

return {
  cycle = cycle,
  distinct = distinct,
  enumerate = enumerate,
  filter = filter,
  firstDuplicate = firstDuplicate,
  flatMap = flatMap,
  map = map,
  range = range,
  reduce = reduce,
  rep = rep,
  take = take,
}
