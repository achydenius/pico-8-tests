local renderer = {}

local function trace(a, b, table)
  if a[2] > b[2] then
    a, b = b, a
  end

  local ax, ay = a[1], a[2]
  local bx, by = b[1], b[2]

  local dx = (bx - ax) / (by - ay)
  local ex = 1 - (a[2] - flr(a[2]))
  local x = ax + (dx * ex)

  for y = flr(ay), by - 1 do
    table[y] = flr(x)
    x += dx
  end
end

renderer.render = function(vertices, normal)
  local left, right = {}, {}

  -- Clear edge tables
  for i = 1, 128 do
    left[i], right[i] = -1, -1
  end

  -- Define winding
  local winding = 0
  for i = 1, #vertices do
    local a, b = vertices[i], vertices[(i % #vertices) + 1]
    winding += (b[1] - a[1]) * (b[2] + a[2])
  end

  if winding > 0 then
    return
  end

  -- Trace edges
  for i = 1, #vertices do
    local a, b = vertices[i], vertices[(i % #vertices) + 1]
    local table = ((winding < 0 and a[2] > b[2]) or (winding > 0 and a[2] < b[2]))
      and left
      or right

    trace(a, b, table)
  end

  -- Define color
  local palette = { 1, 5, 6, 7 }
  local index = flr(-normal[3] * #palette) + 1
  if index < 1 then
    index = 1
  elseif index > #palette then
    index = #palette
  end

  local color = palette[index]

  -- Rasterize
  for y = 1, 128 do
    local start_x = left[y]
    local end_x = right[y]

    line(start_x, y, end_x, y, color)
  end
end

return renderer
