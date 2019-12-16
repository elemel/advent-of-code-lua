local function bounds(grid)
  local minX = math.huge
  local minY = math.huge

  local maxX = -math.huge
  local maxY = -math.huge

  for y, row in pairs(grid) do
    for x in pairs(row) do
      minX = math.min(minX, x)
      minY = math.min(minY, y)

      maxX = math.max(maxX, x)
      maxY = math.max(maxY, y)
    end
  end

  return minX, minY, maxX, maxY
end

local function getCell(grid, x, y)
  return grid[y] and grid[y][x]
end

local function setCell(grid, x, y, v)
  if v == nil then
    if grid[y] then
      grid[y][x] = nil

      if next(grid[y]) == nil then
        grid[y] = nil
      end
    end
  else
    grid[y] = grid[y] or {}
    grid[y][x] = v
  end
end

local function printGrid(grid, defaultCell)
  defaultCell = defaultCell or " "
  local minX, minY, maxX, maxY = bounds(grid)

  for y = minY, maxY do
    local row = grid[y]

    if row == nil then
      print(string.rep(defaultCell, maxX - minX + 1))
    else
      local chars = {}

      for x = minX, maxX do
        chars[#chars + 1] = row[x] or defaultCell
      end

      print(table.concat(chars))
    end
  end
end

return {
  bounds = bounds,
  getCell = getCell,
  printGrid = printGrid,
  setCell = setCell,
}
