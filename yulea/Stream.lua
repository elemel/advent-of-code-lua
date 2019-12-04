local Stream = {}
Stream.__index = Stream

function Stream.new(iterator)
  local instance = {
    _iterator = assert(iterator),
  }

  return setmetatable(instance, Stream)
end

function Stream:__call()
  return self._iterator()
end

function Stream:map(f)
  return Stream.new(function()
    local v = self._iterator()

    if v == nil then
      return nil
    end

    return f(v)
  end)
end

function Stream:filter(f)
  return Stream.new(function()
    local v = self._iterator()

    while v ~= nil and not f(v) do
      v = self._iterator()
    end

    return v
  end)
end

return Stream
