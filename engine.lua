local math = require("math")
local quicksort = require("quicksort")
local rasterizer = require("rasterizer")

local engine = {}

engine.create_object = function(mesh)
  local mt = {}
  local object = {
    mesh = mesh,
    matrix = math.matrix_identity()
  }
  setmetatable(object, mt)
  mt.__index = {
    rotate = function(self, x, y, z)
      self.matrix = math.matrix_rotation(x, y, z)
    end
  }

  return object
end

engine.render = function(object)
  updated = {}
  projected = {}
  updated_normals = {}
  visible_faces = {}

  local mesh = object.mesh

  for i = 1, #mesh.vertices do
    updated[i] = math.vector_multiply(mesh.vertices[i], object.matrix)
    projected[i] = math.vector_project(updated[i], 40)
  end

  for i = 1, #mesh.faces do
    updated_normals[i] = math.vector_multiply(mesh.face_normals[i], object.matrix)
  end

  for i = 1, #mesh.faces do
    local face = mesh.faces[i]
    local vertices = {}
    for j = 1, #face do
      vertices[j] = projected[face[j]]
    end

    -- Define distance
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
      add(visible_faces, {
        vertices = vertices,
        angle = -updated_normals[i][3],
        winding = winding,
        z = z
      })
    end
  end

  quicksort(visible_faces)

  for i = 1, #visible_faces do
    rasterizer.rasterize(visible_faces[i], rasterizer.dithered_func)
  end
end

return engine
