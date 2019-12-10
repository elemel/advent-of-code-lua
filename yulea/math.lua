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

local function rankDirection(x, y)
  if x < 0 then
    if y < 0 then
      -- Southwest
      return 6, -y, -x
    elseif 0 < y then
      -- Northwest
      return 4, -x, y
    else
      -- West
      return 5, 0, -x
    end
  elseif 0 < x then
    if y < 0 then
      -- Southeast
      return 8, x, -y
    elseif 0 < y then
      -- Northeast
      return 2, y, x
    else
      -- East
      return 1, 0, x
    end
  else
    if y < 0 then
      -- South
      return 7, 0, -y
    elseif 0 < y then
      -- North
      return 3, 0, y
    else
      -- Origin
      return 0, 0, 1
    end
  end
end

local function compareDirections(x1, y1, x2, y2)
  local a1, b1, c1 = rankDirection(x1, y1)
  local a2, b2, c2 = rankDirection(x2, y2)

  if a1 ~= a2 then
    return a1 < a2
  end

  return b1 * c2 < b2 * c1
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

local function squaredDistance(x1, y1, x2, y2)
  return (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)
end

local function squaredLength(x, y)
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
  compareDirections = compareDirections,
  digits = digits,
  gcd = gcd,
  maxResult = maxResult,
  minResult = minResult,
  squaredLength = squaredLength,
  squaredDistance = squaredDistance,
  sum = sum,
}
