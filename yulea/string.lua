local function bytes(s)
  return coroutine.wrap(function()
    for i = 1, #s do
      coroutine.yield(string.byte(s, i))
    end
  end)
end

local function escape(s)
  return string.gsub(s, "(%W)", "%%%1")
end

local function join(iterator, separator)
  local t = {}

  for v in iterator do
    t[#t + 1] = v
  end

  return table.concat(t, separator)
end

local function split(s, separator)
  separator = separator or ""

  if separator == "" then
    return coroutine.wrap(function()
      for c in string.gmatch(s, ".") do
        coroutine.yield(c)
      end
    end)
  end

  return coroutine.wrap(function()
    local pattern = "(.-)(" .. separator .. ")"
    local i = 1

    for a, b in string.gmatch(s, pattern) do
      coroutine.yield(a)
      i = i + #a + #b
    end

    coroutine.yield(string.sub(s, i))
  end)
end

local function trim(s)
  return string.match(s, "^%s*(.-)%s*$")
end

return {
  bytes = bytes,
  escape = escape,
  join = join,
  split = split,
  trim = trim,
}
