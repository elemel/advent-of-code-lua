local function bind(f, ...)
  local n = select("#", ...)

  if n == 0 then
    return f
  end

  local a = {...}

  if n == 1 then
    if a[1] == nil then
      return f
    else
      return function(...)
        return f(a[1], ...)
      end
    end
  elseif n == 2 then
    if a[1] == nil then
      if a[2] == nil then
        return f
      else
        return function(b1, ...)
          return f(b1, a[2], ...)
        end
      end
    else
      if a[2] == nil then
        return function(...)
          return f(a[1], ...)
        end
      else
        return function(...)
          return f(a[1], a[2], ...)
        end
      end
    end
  end

  return function(...)
    local m = select("#", ...)
    local b = {...}

    local c = {}
    local j = 1

    for i = 1, n + m do
      if a[i] == nil then
        c[i] = b[j]
        j = j + 1
      else
        c[i] = a[i]
      end
    end

    return f(table.unpack(c))
  end
end

local function index(a, b)
  return a[b]
end

local function len(a)
  return #a
end

return {
  bind = bind,
  index = index,
  len = len,
}
