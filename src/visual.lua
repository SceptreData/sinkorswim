local tiny = require('lib/tiny')

local Animation = require('animation')
local Camera = require('camera')
local Rect = require('rect')
local Vector = require('vec2')

local lg = love.graphics

local Visual = {}
Visual.__index = Visual

local DEBUG_drawBox = true
local DEFAULT_TILE_SIZE = 32

local function drawAnimatedSprite(v, x, y)
  v.animation.cur:draw(v.img, x, y)
end

local function drawStatic(v, x, y)
  lg.draw(v.img, v.sprite, x, y)
end

local function drawEmpty(x, y)
  return
end

local function basic_getPos(e)
  return e.position._local
end

local function relative_getPos(e)
  local pos = e.position:getActual()
  local root = e.position:getRoot()
end

local function actual_getPos(e)
  return e.position:getActual()
end


local POSITION_FUNC_T = {
  basic  = basic_getPos,
  relative = relative_getPos,
  actual = actual_getPos
}

local DEFAULT_DRAW_FUNC = drawAnimatedSprite
local DEFAULT_POS_FUNC  = basic_getPos

function Visual.animatedSprite (img, anim_data, spr_w, spr_h, draw_func, pos_func)
  local v = setmetatable({}, Visual) 
  v._cat = 'animated_sprite'
  v._drawFunc =  draw_func or DEFAULT_DRAW_FUNC

  if type(pos_func) == 'string' then
    pos_func = POSITION_FUNC_T[pos_func]
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
  v._drawFunc = drawStatic
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
  v._drawFunc = drawEmpty
  v._posFunc = actual_getPos

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
    f = POSITION_FUNC_T[f]
  end
  self._posFunc = f
end
  

function Visual:listenFor(event, func)
end


function Visual:update(e, dt)
  if self._dirty then
    local super, sub = self._map[1], self._map[2]
    self.animation:set(super, sub)
    self._dirty = false
  end

  self.animation:update(dt)
end


local function drawBox(x, y, w, h)
  local box = Rect(x, y, w, h)
  box:drawBorder()
end

local function drawMapNode(node, map_x, map_y)
  if not done then print(node:getX() -1, node:getY() -1); done = true end
  drawBox(map_x + ((node:getX()) * 32), map_y + ((node:getY()) * 32), 32, 32)
end

local drawT = {}
function Visual:draw(e, camera)
  local world_pos = self._posFunc(e)
  local screen_pos = camera:translate(world_pos) 
  -- if not drawT[e] then
  --   drawT[e] = pos
  --   print(e.id, pos, tpos)
  -- end

  if self._cat == 'map' then
    e.map:each(drawMapNode, screen_pos.x, screen_pos.y)
  else
    self:_drawFunc(screen_pos.x, screen_pos.y)
    if DEBUG_drawBox then drawBox(screen_pos.x, screen_pos.y, self.spr_w, self.spr_h) end
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
