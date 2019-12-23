local deque = require("deque")
local nums = require("nums")

local bigZero = nums.bn("0")

-- See: https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Modular_integers
local function modularInverseBig(a, n)
  local t = 0
  local newt = 1

  local r = n
  local newr = a

  while newr ~= bigZero do
    local quotient = r / newr

    t, newt = newt, t - quotient * newt
    r, newr = newr, r - quotient * newr
  end

  if r > 1 then
    error("Not invertible")
  end

  if t < 0 then
    t = t + n
  end

  return t
end

local function cut(a, b, n)
  return a, b - n
end

local function dealIntoNewStack(a, b)
  return -a, -1 - b
end

local function dealWithIncrement(a, b, increment)
  return increment * a, increment * b
end

local function shuffle(a, b, technique)
  local n = string.match(technique, "^cut (.+)$")

  if n then
    return cut(a, b, n)
  end

  if technique == "deal into new stack" then
    return dealIntoNewStack(a, b)
  end

  local increment = string.match(technique, "^deal with increment (.+)$")

  if increment then
    return dealWithIncrement(a, b, nums.bn(increment))
  end

  error("Invalid technique: " .. technique)
end

local deckSize = 119315717514047

local a = 1
local b = 0

for line in io.lines() do
  a, b = shuffle(a, b, line)
  a = a % deckSize
  b = b % deckSize
end

local a = modularInverseBig(a, deckSize)
local b = -a * b % deckSize

local shuffleCount = 101741582076661
local position = 2020

while shuffleCount ~= 0 do
  if shuffleCount % 2 == 1 then
    position = (a * position + b) % deckSize
  end

  b = (a * b + b) % deckSize
  a = a * a % deckSize

  shuffleCount = math.floor(shuffleCount / 2)
end

print(position)
