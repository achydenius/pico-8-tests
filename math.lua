local math = {}

math.matrix_identity = function()
  return {
    1, 0, 0,
    0, 1, 0,
    0, 0, 1
  }
end

math.matrix_rotation = function(x, y, z)
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

math.vector_multiply = function(vector, matrix)
  return {
    matrix[1][1] * vector[1] + matrix[1][2] * vector[2] + matrix[1][3] * vector[3],
    matrix[2][1] * vector[1] + matrix[2][2] * vector[2] + matrix[2][3] * vector[3],
    matrix[3][1] * vector[1] + matrix[3][2] * vector[2] + matrix[3][3] * vector[3]
  }
end

math.vector_project = function(vector, d)
  local x = -vector[1] * d / (vector[3] + d)
  local y = vector[2] * d / (vector[3] + d)

  return {
    x + 64,
    y + 64
  }
end

return math
