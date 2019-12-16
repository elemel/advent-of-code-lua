local yulea = require("yulea")

local map = yulea.map
local split = yulea.split
local toArray = yulea.toArray

local basePattern = {0, 1, 0, -1}

local function patternValue(outputIndex, inputIndex)
  return basePattern[math.floor(inputIndex / outputIndex) % 4 + 1]
end

local function fft(input)
  local output = {}

  for outputIndex = 1, #input do
    output[outputIndex] = 0

    for inputIndex, inputValue in ipairs(input) do
      output[outputIndex] =
        output[outputIndex] + inputValue * patternValue(outputIndex, inputIndex)
    end
  end

  for outputIndex = 1, #input do
    output[outputIndex] = math.abs(output[outputIndex]) % 10
  end

  return output
end

local input = toArray(map(split(io.read()), tonumber))

for phase = 1, 100 do
  input = fft(input)
end

print(string.sub(table.concat(input), 1, 8))
