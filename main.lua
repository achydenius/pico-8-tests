math = require("math")
renderer = require("renderer")

points = {
  { -20, 20, 0 },
  { 20, 20, 0 },
  { 20, -20, 0 },
  { -20, -20, 0 }
}
updated = {}
projected = {}

anim = 0

function _update()
  local matrix = math.matrix_rotation(0, anim * 0.25, anim * 0.5)

  for i = 1, #points do
    updated[i] = math.vector_multiply(points[i], matrix)
    projected[i] = math.vector_project(updated[i], 100)
  end
  anim += 0.01
end

function _draw()
  cls(0)
  renderer.render(projected, 7)
end
