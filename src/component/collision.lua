local tiny = require('lib/tiny')

local Rect = require('geometry.rect')

local Collision = {}
Collision.__index = Collision

function Collision.checkBox(e1, e2)
  local box_a = Rect(e1.position.x, e1.position.y, e1.box_w, e1.box_h)
  local box_b = Rect(e2.position.x, e2.position.y, e2.box_w, e2.box_h)
  return box_a:intersects(box_b)
end

Collision.system = tiny.processingSystem()
Collision.system.filter = tiny.requireAll("position", "is_solid")

function Collision.system:process(e, dt)
end 
return Collision
