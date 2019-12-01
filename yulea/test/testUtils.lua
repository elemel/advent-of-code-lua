local function deepEquals(a, b, margin)
  local t = type(a)

  if t ~= type(b) then
    return false
  end

  if t == "number" then
    return math.abs(b - a) <= (margin or 0)
  end

  if t == "table" then
    if getmetatable(a) ~= getmetatable(b) then
      return false
    end

    for k, v in pairs(a) do
      if not deepEquals(v, b[k], margin) then
        return false
      end
    end

    for k, v in pairs(b) do
      if not deepEquals(v, a[k], margin) then
        return false
      end
    end

    return true
  end

  return a == b
end

return {
  deepEquals = deepEquals,
}
