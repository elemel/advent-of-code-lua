local deque = require("deque")
local yulea = require("yulea")

local enumerate = yulea.enumerate

local function cut(deck, n)
  if n < 0 then
    deck:rotate_right(-n)
  else
    deck:rotate_left(n)
  end
end

local function dealIntoNewStack(deck)
  local stack = {}

  while not deck:is_empty() do
    stack[#stack + 1] = deck:pop_left()
  end

  for _, card in ipairs(stack) do
    deck:push_left(card)
  end
end

local function dealWithIncrement(deck, increment)
  local n = deck:length()
  local line = {}
  local i = 1

  while not deck:is_empty() do
    line[i] = deck:pop_left()
    i = (i + increment - 1) % n + 1
  end

  for _, card in ipairs(line) do
    deck:push_right(card)
  end
end

local function shuffle(deck, technique)
  local n = string.match(technique, "^cut (.+)$")

  if n then
    cut(deck, tonumber(n))
    return
  end

  if technique == "deal into new stack" then
    dealIntoNewStack(deck)
    return
  end

  local increment = string.match(technique, "^deal with increment (.+)$")

  if increment then
    dealWithIncrement(deck, tonumber(increment))
    return
  end

  error("Forbidden technique: " .. technique)
end

local function findCard(deck, card)
  for position, card2 in enumerate(deck:iter_left(), 0) do
    if card2 == card then
      return position
    end
  end

  return nil
end

local deck = deque.new()

for card = 0, 10006 do
  deck:push_right(card)
end

for line in io.lines() do
  shuffle(deck, line)
end

print(findCard(deck, 2019))
