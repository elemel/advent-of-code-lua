local function accumulate(iterator)
  return coroutine.wrap(function()
    local result = 0

    for element in iterator do
      result = result + element
      coroutine.yield(result)
    end
  end)
end

local function digits(n, base)
  base = base or 10
  local result = {}

  repeat
    result[#result + 1] = n % base
    n = math.floor(n / base)
  until n == 0

  local i = 1
  local j = #result

  while i < j do
    result[i], result[j] = result[j], result[i]

    i = i + 1
    j = j - 1
  end

  return result
end

local function maxResult(iterator)
  local result

  for element in iterator do
    if result == nil or result < element then
      result = element
    end
  end

  return result
end

local function minResult(iterator)
  local result

  for element in iterator do
    if result == nil or element < result then
      result = element
    end
  end

  return result
end

local function sum(iterator)
  local result = 0

  for element in iterator do
    result = result + element
  end

  return result
end

return {
  accumulate = accumulate,
  digits = digits,
  maxResult = maxResult,
  minResult = minResult,
  sum = sum,
}
