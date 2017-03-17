-- Prop Factory
local Position = require('position')
local Vector = require('vec2')
local Visual = require('visual')
local Prop = {}
Prop.__index = Prop

function Prop.new(id, frame_idx, is_solid)
  local data = Atlas.prop[id]

  local p = setmetatable({}, Prop)
  p.id = id
  p.position = Position()
  p.visual = Visual.prop(data.img, data.frames[frame_idx], data.sw, data.sh)
  p.visual:setPosFunc('actual')
  p.box_w, p.box_h = data.sw, data.sh

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
