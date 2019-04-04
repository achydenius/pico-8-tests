pico-8 cartridge // http://www.pico-8.com
version 16
__lua__

points = {
  { -20, 20, 20 },
  { 20, 20, 20 },
  { 20, -20, 20 },
  { -20, -20, 20 },
  { -20, 20, -20 },
  { 20, 20, -20 },
  { 20, -20, -20 },
  { -20, -20, -20 }
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

function get_size(z)
  if z > 10 then
    return 1
  elseif z > 0 then
    return 2
  elseif z > -10 then
    return 3
  else
    return 4
  end
end

function get_sprite(z)
  if z > 10 then
    return 3
  elseif z > 0 then
    return 2
  elseif z > -10 then
    return 1
  else
    return 0
  end
end

function _update()
  local matrix = get_rotation(anim, anim * 0.5, anim * 0.25)

  for i = 1, #points do
    updated[i] = multiply(points[i], matrix)
    projected[i] = project(updated[i], 100)
  end
  anim += 0.01
end

function _draw()
  cls(0)
  for i = 1, #updated do
    spr(get_sprite(updated[i][3]), projected[i][1], projected[i][2])
  end
end
