math = require("math")
renderer = require("renderer")
model = require("model")

updated = {}
projected = {}
updated_normals = {}

anim = 0

function _update()
  local matrix = math.matrix_rotation(0, anim * 0.25, anim * 0.5)

  for i = 1, #model.vertices do
    updated[i] = math.vector_multiply(model.vertices[i], matrix)
    projected[i] = math.vector_project(updated[i], 40)
  end

  for i = 1, #model.faces do
    updated_normals[i] = math.vector_multiply(model.face_normals[i], matrix)
  end

  anim += 0.01
end

function _draw()
  cls(12)
  for i = 1, #model.faces do
    local vertices = {}
    for j = 1, #model.faces[i] do
      vertices[j] = projected[model.faces[i][j]]
    end
    renderer.render(vertices, updated_normals[i])
  end
end
