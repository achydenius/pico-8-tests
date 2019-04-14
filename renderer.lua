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

renderer.render = function(face, color_func)
  local left, right = {}, {}

  -- Clear edge tables
  for i = 1, 128 do
    left[i], right[i] = -1, -1
  end

  -- Trace edges
  for i = 1, #face.vertices do
    local a, b = face.vertices[i], face.vertices[(i % #face.vertices) + 1]
    local table = ((face.winding < 0 and a[2] > b[2]) or (face.winding > 0 and a[2] < b[2]))
      and left
      or right

    trace(a, b, table)
  end

  -- Define color
  local color = color_func(face.angle)

  -- Rasterize
  for y = 1, 128 do
    local start_x = left[y]
    local end_x = right[y]

    line(start_x, y, end_x, y, color)
  end
end

return renderer
