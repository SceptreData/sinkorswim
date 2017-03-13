local Animation = require('animation')

local Visual = {}
Visual.__index = Visual

local DEBUG_drawBox = true

local function drawAnimatedSprite(v, x, y)
  v.animation.cur:draw(v.img, x, y)
end

local DEFAULT_TILE_SIZE = 32
local DEFAULT_DRAW_FUNC = drawAnimatedSprite

function Visual.animatedSprite (img, anim_data, spr_w, spr_h, draw_func)
  local v = setmetatable({}, Visual) 
  v._cat = 'animated_sprite'
  v._drawFunc =  draw_func or DEFAULT_DRAW_FUNC
  v._dirty = false

  v._posFunc =

  v.img = img
  v.spr_w, v.spr_h = spr_w or DEFAULT_TILE_SIZE, spr_h or DEFAULT_TILE_SIZE
  v.animation = Animation.attach(anim_data)

  v._map = {}
  --v.registered_events = {}
  return v
end


function Visual:setVisualMap  (t)
  self._map = t
end
  

function Visual:flag()
  self._dirty = true
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

function Visual:draw(e)
  --if DEBUG_drawBox then
  self._drawFunc(self, 
   


Visual.system = tiny.processingSystem()
Visual.system.filter = tiny.requireAll("visual", "position", "location")
function Visual.system:process(e, dt)

end

