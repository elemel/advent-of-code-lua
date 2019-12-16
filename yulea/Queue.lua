local Queue = {}
Queue.__index = Queue

function Queue.new()
  return setmetatable({first = 1, last = 0}, Queue)
end

function Queue:push(value)
  assert(value ~= nil, "Nil value")
  self.last = self.last + 1
  self[self.last] = value
end

function Queue:pop()
  assert(self.first <= self.last, "Empty queue")
  local result = self[self.first]
  self[self.first] = nil
  self.first = self.first + 1
  return result
end

function Queue:isEmpty()
  return self.first > self.last
end

return Queue
