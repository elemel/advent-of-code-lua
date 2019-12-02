local function bytes(s)
  return coroutine.wrap(function()
    for i = 1, #s do
      coroutine.yield(string.byte(s, i))
    end
  end)
end

local function chars(s)
  return coroutine.wrap(function()
    for i = 1, #s do
      coroutine.yield(string.sub(s, i, i))
    end
  end)
end

local function escape(s)
  return string.gsub(s, "(%W)", "%%%1")
end

local function split(s, separator)
  separator = separator or "%s+"

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

local function words(s)
  return coroutine.wrap(function()
    for w in string.gmatch(s, "%S+") do
      coroutine.yield(w)
    end
  end)
end

return {
  bytes = bytes,
  chars = chars,
  escape = escape,
  split = split,
  trim = trim,
  words = words,
}
