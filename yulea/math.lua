local function accumulate(iterator)
  return coroutine.wrap(function()
    local result = 0

    for element in iterator do
      result = result + element
      coroutine.yield(result)
    end
  end)
end

local function all(iterator)
  local result = true

  for element in iterator do
    result = result and element
  end

  return result
end

local function any(iterator)
  local result = false

  for element in iterator do
    result = result or element
  end

  return result
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

local function gcd(a, b)
  while b ~= 0 do
      a, b = b, a % b
  end

  return math.abs(a)
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

local function squaredDistance2(x1, y1, x2, y2)
  return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
end

local function squaredLength2(x, y)
  return x * x + y * y
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
  all = all,
  any = any,
  digits = digits,
  gcd = gcd,
  maxResult = maxResult,
  minResult = minResult,
  squaredLength2 = squaredLength2,
  squaredDistance2 = squaredDistance2,
  sum = sum,
}
