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

local function trim(s)
   return string.match(s, "^%s*(.-)%s*$")
end

local function words(s)
  return coroutine.wrap(function()
    for w in s:gmatch("%S+") do
      coroutine.yield(w)
    end
  end)
end

return {
  bytes = bytes,
  chars = chars,
  trim = trim,
  words = words,
}
