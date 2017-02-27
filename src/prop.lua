-- Prop Factory
local Vector = require('vec2')

local Prop = {}
Prop.__index = Prop

function Prop.new(id, frame_idx, x, y, is_solid)
  local data = Atlas.prop[id]

  local p = setmetatable({}, Prop)
  p.id = id
  p.img = data.img
  p.sprite = data.frames[frame_idx]
  p.box_w, p.box_h = data.sw, data.sh

  p.position = Vector(x or 0, y or 0)
  p.is_solid = is_solid or false

  -- Debug
  p.drawBox = false

  return p
end

function Prop:draw()
  love.graphics.draw(self.img, self.sprite, self.position.x, self.position.y)
end

setmetatable(Prop, {__call = function(_, ...) return Prop.new(...) end})
return Prop
