local ansicolors = require("yulea.test.ansicolors")

local function sortedPairs(t)
  local keys = {}

  for k, v in pairs(t) do
    table.insert(keys, k)
  end

  table.sort(keys)

  return coroutine.wrap(function()
    for _, k in ipairs(keys) do
      coroutine.yield(k, t[k])
    end
  end)
end

local testSuites = {
  functionalTest = require("yulea.test.functionalTest"),
  iteratorTest = require("yulea.test.iteratorTest"),
  mathTest = require("yulea.test.mathTest"),
  stringTest = require("yulea.test.stringTest"),
  tableTest = require("yulea.test.tableTest"),
}

for testSuiteName, testCases in sortedPairs(testSuites) do
  for testCaseName, testCase in sortedPairs(testCases) do
    local testName = testSuiteName .. "." .. testCaseName

    testCase()

    if pcall(testCase) then
      print(ansicolors("%{green}" .. testName .. ": PASS"))
    else
      print(ansicolors("%{red}" .. testName .. ": FAIL"))
    end
  end
end
