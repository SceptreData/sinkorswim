local Animation = require('animation')
local Rect = require('rect')
local Vector = require('vec2')

local Visual = {}
Visual.__index = Visual

local DEBUG_drawBox = true


local function drawAnimatedSprite(v, x, y)
  v.animation.cur:draw(v.img, x, y)
end


local function basic_getPos(e)
  return e.position.x, e.position.y
end


local DEFAULT_TILE_SIZE = 32
local DEFAULT_DRAW_FUNC = drawAnimatedSprite
local DEFAULT_POS_FUNC  = basic_getPos

function Visual.animatedSprite (img, anim_data, spr_w, spr_h, draw_func, pos_func)
  local v = setmetatable({}, Visual) 
  v._cat = 'animated_sprite'
  v._drawFunc =  draw_func or DEFAULT_DRAW_FUNC
  v._posFunc = pos_func or DEFAULT_POS_FUNC

  v.img = img
  v.spr_w, v.spr_h = spr_w or DEFAULT_TILE_SIZE, spr_h or DEFAULT_TILE_SIZE
  v.animation = Animation.attach(anim_data)

  v._map = {}
  --v.registered_events = {}
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
  self._posFunc = f
end
  

function Visual:listenFor(event, func)
end


function Visual:update(e, dt)
  if self._dirty then
    local super, sub = e[self._map[1], self._map[2]]
    self.animation:set(super, sub)
    self._dirty = false
  end

  self.animation:update(dt)
end


local function drawBox(x, y, w, h)
  local box = Rect(x, y, w, h)
  box:drawBorder()
end

function Visual:draw(e)
  local x, y = self:getPosition(e)
  if DEBUG_drawBox then drawBox(x, y, self.spr_w, self.spr_h) end

  self:_drawFunc(x, y)
end
   

Visual.system = tiny.processingSystem()
Visual.system.filter = tiny.requireAll("visual", "position", "location")
function Visual.system:process(e, dt)

end

