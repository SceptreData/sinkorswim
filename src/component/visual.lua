local tiny = require('lib/tiny')

local Animation = require('component.animation')
local Draw      = require('draw')
local Camera    = require('camera')
local Position  = require('component.position')
local Rect      = require('geometry.rect')
local Vector    = require('math.vec2')

local lg = love.graphics

local Visual = {}
Visual.__index = Visual

local DEBUG_drawBox = true
local DEFAULT_TILE_SIZE = 32

local DEFAULT_DRAW_FUNC = Draw.animatedSprite
local DEFAULT_POS_FUNC  = Position.func_t['actual']

local function new(v_data)
  local v = setmetatable({}, Visual)

  v._id      = v_data.id
  v.priority = v_data.priority
  v.img      = v_data.img or nil
  v.map      = v_data.map or nil
  v.spr_w, v.spr_h = v_data.w, v_data.h

  v._drawFunc = Draw[v_data.id]
  v._posFunc  = v_data.posFunc or DEFAULT_POS_FUNC

  if v_data.anim then
    v.animation = Animation.attach(v_data.anim)
  end
  v.sprite = v_data.sprite_frame or nil

  v._dirty = false
  return v
end


function Visual:flag()
  self._dirty = true
end


function Visual:setMap  (t)
  self._map = t
end


function Visual:setDrawFunc(f)
  self._drawFunc = f
end


function Visual:setPosFunc(f)
  if type(f) == 'string' then
    f = Position.func_t[f]
  end
  self._posFunc = f
end
  
-- TODO: Event System, so animations can update on events.
-- function Visual:listenFor(event, func)
-- end


function Visual:update(e, dt)
  if self._dirty then
    local super, sub = self._map[1], self._map[2]
    self.animation:set(super, sub)
    self._dirty = false
  end

  self.animation:update(dt)
end


function Visual:draw(e, camera)
  local world_pos  = self._posFunc(e)
  local screen_pos = camera:translate(world_pos) 

    --e.map:each(Draw.mapNode, screen_pos.x, screen_pos.y)
    self:_drawFunc(screen_pos.x, screen_pos.y)
    if DEBUG_drawBox then Draw.box(screen_pos.x, screen_pos.y, self.spr_w, self.spr_h) end
  end
end

function Visual.system:sort()
  table.sort(self.entities, function(a, b)
    return a.visual.priority < b.visual.priority
  end)
end

Visual.system = tiny.processingSystem()
--Visual.system = tiny.sortedProcessingSystem()
Visual.system.filter = tiny.requireAll("visual", "position")
function Visual.system:process(e)
  if Game.cam:canSee(e) then
    e.visual:draw(e, Game.cam)
  end
end

setmetatable(Visual, {__call = function(_, ...) return new(...) end})

return Visual
