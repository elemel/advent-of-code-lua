local function array(iterator, result)
  result = result or {}

  for element in iterator do
    table.insert(result, element)
  end

  return result
end

local function elements(t)
  return coroutine.wrap(function()
    for _, e in ipairs(t) do
      coroutine.yield(e)
    end
  end)
end

local function compare(t1, t2, compareElement)
  compareElement = compareElement or function(v1, v2) return v1 < v2 end

  for i = 1, math.min(#t1, #t2) do
    if compareElement(t1[i], t2[i]) then
      return true
    elseif compareElement(t2[i], t1[i]) then
      return false
    end
  end

  return #t1 < #t2
end

local function keys(t)
  return coroutine.wrap(function()
    for k in pairs(t) do
      coroutine.yield(k)
    end
  end)
end

local function mapValues(t, mapper, result)
  result = result or {}

  for k, v in pairs(t) do
    result[k] = mapper(v)
  end

  return result
end

local function memoize(f)
  return setmetatable({}, {
    __index = function(t, k)
      local v = f(k)
      t[k] = v
      return v
    end
  })
end

local function multiset(iterator, result)
  result = result or {}

  for element in iterator do
    result[element] = (result[element] or 0) + 1
  end

  return result
end

local function reverse(t)
  local i = 1
  local j = #t

  while i < j do
    t[i], t[j] = t[j], t[i]

    i = i + 1
    j = j - 1
  end
end

local function values(t)
  return coroutine.wrap(function()
    for _, v in pairs(t) do
      coroutine.yield(v)
    end
  end)
end

return {
  array = array,
  compare = compare,
  elements = elements,
  keys = keys,
  mapValues = mapValues,
  memoize = memoize,
  multiset = multiset,
  reverse = reverse,
  values = values,
}
