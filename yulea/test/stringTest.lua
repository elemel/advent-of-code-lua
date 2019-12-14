local testUtils = require("yulea.test.testUtils")
local yulea = require("yulea")

local deepEquals = testUtils.deepEquals
local escape = yulea.string.escape
local split = yulea.string.split
local toArray = yulea.table.toArray
local words = yulea.string.words

local stringTest = {}

function stringTest.testEscape()
  assert(escape("word") == "word")
  assert(escape("%w") == "%%w")
end

function stringTest.testSplit()
  assert(deepEquals(toArray(split("xyz", "x")), {"", "yz"}))
  assert(deepEquals(toArray(split("", "x")), {""}))
  assert(deepEquals(toArray(split("a, b, c", ", ")), {"a", "b", "c"}))

  assert(deepEquals(
    toArray(split("https://adventofcode.com/", "/")),
    {"https:", "", "adventofcode.com", ""}))
end

return stringTest
