local function accumulate(iterator)
  return coroutine.wrap(function()
    local result = 0

    for element in iterator do
      result = result + element
      coroutine.yield(result)
    end
  end)
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
  maxResult = maxResult,
  minResult = minResult,
  sum = sum,
}
