local testUtils = require("yulea.test.testUtils")
local yulea = require("yulea")

local array = yulea.table.array
local deepEquals = testUtils.deepEquals
local escape = yulea.string.escape
local split = yulea.string.split
local words = yulea.string.words

local stringTest = {}

function stringTest.testEscape()
  assert(escape("word") == "word")
  assert(escape("%w") == "%%w")
end

function stringTest.testSplit()
  assert(deepEquals(array(split("xyz", "x")), {"", "yz"}))
  assert(deepEquals(array(split("", "x")), {""}))
  assert(deepEquals(array(split("a, b, c", ", ")), {"a", "b", "c"}))

  assert(deepEquals(
    array(split("https://adventofcode.com/", "/")),
    {"https:", "", "adventofcode.com", ""}))
end

function stringTest.testWords()
  local iterator = words(" No \tfinal\n escape  ")

  assert(iterator() == "No")
  assert(iterator() == "final")
  assert(iterator() == "escape")
  assert(iterator() == nil)
end

return stringTest
