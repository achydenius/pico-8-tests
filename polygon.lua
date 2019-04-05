function trace(a, b, table)
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

function render(vertices, color)
  local left, right = {}, {}

  -- Clear edge tables
  for i = 1, 128 do
    left[i], right[i] = -1, -1
  end

  -- Define winding
  local sum = 0
  for i = 1, #vertices do
    local a, b = vertices[i], vertices[(i % #vertices) + 1]
    sum += (b[1] - a[1]) * (b[2] + a[2])
  end

  -- Trace edges
  for i = 1, #vertices do
    local a, b = vertices[i], vertices[(i % #vertices) + 1]
    local table = ((sum < 0 and a[2] > b[2]) or (sum > 0 and a[2] < b[2]))
      and left
      or right

    trace(a, b, table)
  end

  -- Rasterize
  for y = 1, 128 do
    for x = left[y], right[y] do
      pset(x, y, color)
    end
  end
end
