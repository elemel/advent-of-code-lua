local function numbers(file)
  return coroutine.wrap(function()
    while true do
      local number = file:read("*number")

      if number == nil then
        break
      end

      coroutine.yield(number)
    end
  end)
end

return {
  numbers = numbers,
}
