math = require("math")
renderer = require("renderer")
model = require("model")
quicksort = require("quicksort")

updated = {}
projected = {}
updated_normals = {}
visible_faces = {}

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

  visible_faces = {}
  for i = 1, #model.faces do
    local face = model.faces[i]
    local vertices = {}
    for j = 1, #face do
      vertices[j] = projected[face[j]]
    end

    local z = 0
    for j = 1, #face do
      z += updated[face[j]][3]
    end

    -- Define winding
    local winding = 0
    for j = 1, #vertices do
      local a, b = vertices[j], vertices[(j % #vertices) + 1]
      winding += (b[1] - a[1]) * (b[2] + a[2])
    end

    if winding < 0 then
      -- Define color
      local palette = { 1, 5, 6, 7 }
      local index = flr(-updated_normals[i][3] * #palette) + 1
      if index < 1 then
        index = 1
      elseif index > #palette then
        index = #palette
      end

      local color = palette[index]

      add(visible_faces, {
        vertices = vertices,
        color = color,
        winding = winding,
        z = z
      })
    end
  end

  quicksort(visible_faces)

  anim += 0.01
end

function _draw()
  cls(12)
  for i = 1, #visible_faces do
    local face = visible_faces[i]
    renderer.render(face.vertices, face.color, face.winding)
  end
end
