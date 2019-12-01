local yulea = require("yulea")

local bind = yulea.functional.bind

local functionalTest = {}

function functionalTest.testBind()
  bind(function(a, b, c)
    assert(a == 1)
    assert(b == 2)
    assert(c == 3)
  end, nil, 2)(1, 3)
end

return functionalTest
