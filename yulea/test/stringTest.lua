local yulea = require("yulea")

local words = yulea.string.words

local stringTest = {}

function stringTest.testWords()
  local iterator = words(" No \tfinal\n escape  ")

  assert(iterator() == "No")
  assert(iterator() == "final")
  assert(iterator() == "escape")
  assert(iterator() == nil)
end

return stringTest
