local tiny = require('lib/tiny')

local Animation = require('animation')
local Draw = require('draw')
local Camera = require('camera')
local Position = require('position')
local Rect = require('rect')
local Vector = require('vec2')

local lg = love.graphics

local Visual = {}
Visual.__index = Visual

local DEBUG_drawBox = true
local DEFAULT_TILE_SIZE = 32

local DEFAULT_DRAW_FUNC = Draw.animatedSprite
local DEFAULT_POS_FUNC  = Position.func_t['actual']


function Visual.animatedSprite (img, anim_data, spr_w, spr_h, draw_func, pos_func)
  local v = setmetatable({}, Visual) 
  v._cat = 'animated_sprite'
  v._drawFunc = Draw.animatedSprite

  if type(pos_func) == 'string' then
    pos_func = Position.func_t[pos_func]
  end
  v._posFunc = pos_func or DEFAULT_POS_FUNC

  v.img = img
  v.spr_w, v.spr_h = spr_w or DEFAULT_TILE_SIZE, spr_h or DEFAULT_TILE_SIZE
  v.animation = Animation.attach(anim_data)

  v._map = {}
  --v.registered_events = {}
  v._dirty = false

  return v
end


function Visual.prop(img, sprite, w, h)
  local v = setmetatable({}, Visual)
  v._cat = 'prop'
  v._drawFunc = Draw.static
  v._posFunc = DEFAULT_POS_FUNC
  v.img = img
  v.sprite =  sprite
  v.spr_w, v.spr_h = w or DEFAULT_TILE_SIZE, h or DEFAULT_TILE_SIZE
  v._dirty = false

  return v
end


function Visual.emptyMap (w, h, tile_size)
  local v = setmetatable({}, Visual)
  v._cat = 'map'
  v._drawFunc = Draw.empty
  v._posFunc = Position.func_t['actual']

  v.spr_w, v.spr_h = 32, 32
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
  local world_pos = self._posFunc(e)
  local screen_pos = camera:translate(world_pos) 

  if self._cat == 'map' then
    e.map:each(Draw.mapNode, screen_pos.x, screen_pos.y)
  else
    self:_drawFunc(screen_pos.x, screen_pos.y)
    if DEBUG_drawBox then Draw.box(screen_pos.x, screen_pos.y, self.spr_w, self.spr_h) end
  end
end
   

Visual.system = tiny.processingSystem()
Visual.system.filter = tiny.requireAll("visual", "position")
function Visual.system:process(e)
  if Game.cam:canSee(e) then
    e.visual:draw(e, Game.cam)
  end
end

return Visual
