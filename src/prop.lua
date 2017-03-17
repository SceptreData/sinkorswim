-- Prop Factory
local Position = require('component.position')
local Vector = require('math.vec2')
local Visual = require('component.visual')
local Prop = {}
Prop.__index = Prop

function Prop.new(id, frame_idx, is_solid)
  local data = Atlas.prop[id]

  local p = setmetatable({}, Prop)
  p.id = id
  p.position = Position()
  p.box_w, p.box_h = data.sw, data.sh

  p.visual = Visual({
    id = 'static',
    img = data.img,
    sprite_frame = data.frames[frame_idx],
    w = data.sw,
    h = data.sh
  })
  p.is_solid = is_solid or false

  return p
end

function Prop:place(x, y, location)
  local target = location or self.position.location
  local map = target.map

  if map then
    assert(map:notBlockedAt(x, y))
  end
    
  self.position:set(x, y, location or nil)
end

setmetatable(Prop, {__call = function(_, ...) return Prop.new(...) end})
return Prop
