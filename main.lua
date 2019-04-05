require("polygon")

points = {
  { -20, 20, 0 },
  { 20, 20, 0 },
  { 20, -20, 0 },
  { -20, -20, 0 }
}
updated = {}
projected = {}

anim = 0

function get_rotation(x, y, z)
  return {
    {
      cos(y) * cos(z),
      cos(y) * sin(z),
      -sin(y)
    },
    {
      (sin(x) * sin(y) * cos(z)) - (cos(x) * sin(z)),
      (sin(x) * sin(y) * sin(z)) + (cos(x) * cos(z)),
      sin(x) * cos(y)
    },
    {
      (cos(x) * sin(y) * cos(z)) + (sin(x) * sin(z)),
      (cos(x) * sin(y) * sin(z)) - (sin(x) * cos(z)),
      cos(x) * cos(y)
    }
  }
end

function multiply(vector, matrix)
  return {
    matrix[1][1] * vector[1] + matrix[1][2] * vector[2] + matrix[1][3] * vector[3],
    matrix[2][1] * vector[1] + matrix[2][2] * vector[2] + matrix[2][3] * vector[3],
    matrix[3][1] * vector[1] + matrix[3][2] * vector[2] + matrix[3][3] * vector[3]
  }
end

function project(vector, d)
  local x = -vector[1] * d / (vector[3] + d)
  local y = vector[2] * d / (vector[3] + d)

  return {
    x + 64,
    y + 64
  }
end

function _update()
  local matrix = get_rotation(0, anim * 0.25, anim * 0.5)

  for i = 1, #points do
    updated[i] = multiply(points[i], matrix)
    projected[i] = project(updated[i], 100)
  end
  anim += 0.01
end

function _draw()
  cls(0)
  render(projected, 7)
end
