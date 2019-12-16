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

local function copy(t, result)
  result = result or {}

  for k, v in pairs(t) do
    result[k] = v
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

local function findValue(t, v)
  for k, v2 in pairs(t) do
    if v2 == v then
      return k
    end
  end

  return nil
end

local function histogram(iterator, result)
  result = result or {}

  for element in iterator do
    result[element] = (result[element] or 0) + 1
  end

  return result
end

local function isSorted(t, compare)
  compare = compare or function(a, b) return a < b end

  for i = 2, #t do
    if compare(t[i], t[i - 1]) then
      return false
    end
  end

  return true
end

local function keys(t)
  local k

  return function()
    k = next(t, k)
    return k
  end
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
    __call = function(t, k)
      return t[k]
    end,

    __index = function(t, k)
      local v = f(k)
      t[k] = v
      return v
    end,
  })
end

-- Adapted from: https://www.lua.org/pil/9.3.html
local function permgen(a, n)
  if n == 0 then
    coroutine.yield(a)
  else
    for i = 1, n do

      -- put i-th element as the last one
      a[n], a[i] = a[i], a[n]

      -- generate all permutations of the other elements
      permgen(a, n - 1)

      -- restore i-th element
      a[n], a[i] = a[i], a[n]
    end
  end
end

local function permutations(t)
  return coroutine.wrap(function() permgen(t, #t) end)
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

local function setOf(...)
  local result = {}

  for i, v in ipairs({...}) do
    result[v] = true
  end

  return result
end

local function slice(t, first, last, step)
  first = first or 1
  last = last or math.huge
  step = step or 1

  return coroutine.wrap(function()
    for i = first, last, step do
      coroutine.yield(t[i])
    end
  end)
end

local function tableOf(...)
  local n = select("#", ...)
  assert(n % 2 == 0, "Odd argument count")

  local args = {...}
  local result = {}

  for i = 1, n, 2 do
    result[args[i]] = args[i + 1]
  end

  return result
end

local function toArray(iterator, result, first, last, step)
  result = result or {}
  first = first or 1
  last = last or math.huge
  step = step or 1

  for i = first, last, step do
    local element = iterator()

    if element == nil then
      break
    end

    result[i] = element
  end

  return result
end

local function topologicalSort(dependencies, result)
  result = result or {}

  while next(dependencies) do
    for target, sources in pairs(dependencies) do
      for source in pairs(sources) do
        if not dependencies[source] then
          sources[source] = nil
          break
        end
      end

      if not next(sources) then
        dependencies[target] = nil
        result[#result + 1] = target
      end
    end
  end

  return result
end

local function toSet(iterator, result)
  result = result or {}

  for element in iterator do
    result[element] = true
  end

  return result
end

local function toTable(iterator, result)
  result = result or {}

  for k, v in iterator do
    result[k] = v
  end

  return result
end

local function values(t)
  local k, v

  return function()
    k, v = next(t, k)
    return v
  end
end

return {
  compare = compare,
  copy = copy,
  elements = elements,
  findValue = findValue,
  histogram = histogram,
  isSorted = isSorted,
  keys = keys,
  mapValues = mapValues,
  memoize = memoize,
  permutations = permutations,
  reverse = reverse,
  setOf = setOf,
  slice = slice,
  tableOf = tableOf,
  toArray = toArray,
  topologicalSort = topologicalSort,
  toSet = toSet,
  toTable = toTable,
  values = values,
}
