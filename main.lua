mesh = require("mesh")
engine = require("engine")

local anim = 0
local object = engine.create_object(mesh)

function _update()
  object:rotate(0, anim * 0.25, anim * 0.5)
  anim += 0.01
end

function _draw()
  cls(0)
  engine.render(object)
end
