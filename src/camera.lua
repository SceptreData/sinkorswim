local lume = require('lib/lume')

local Position = require('component.position')
local Rect = require('geometry.rect')
local Vector = require('math.vec2')

local Camera = {}
Camera.__index = Camera

local DEFAULT_TILE_SIZE = 32

-- x, y coordinates
local function new(x, y, location, viewport)
  local c = setmetatable({}, Camera)
  c.pos = Position(x or 0, y or 0, location or nil)
  c.rot = 0
  c.zoom = 1
  c.viewport = viewport or nil
  return c
end


function Camera:goTo(x, y)
  self.pos:set(x, y)
end


function Camera:lookAt(ent)
  local pos = ent.position:getActual()
  if ent.width then
    pos.x = pos.x + (ent.width * 0.5)
    pos.y = pos.y + (ent.height * 0.5)
  end

  self:goTo(pos.x, pos.y)
end


function Camera:move(dx, dy)
end

function Camera:screenLocation()
  assert(self.viewport)
  return self.viewport.position:getActual()
end

function Camera:getDimensions()
  assert(self.viewport, "Camera must be attached to viewport!")
  local scale = DEFAULT_TILE_SIZE * self.zoom
  return self.viewport.width / scale, self.viewport.height / scale
end


function Camera:translate(pos)
  local view_pos = self.viewport.position:get()
  local cam_w, cam_h = self:getDimensions()
  local origin = self.pos:get() - Vector(cam_w / 2, cam_h / 2)
  local offset = Vector(pos.x - 1, pos.y - 1) - origin

  return view_pos + offset:scale(DEFAULT_TILE_SIZE * self.zoom)
end


function Camera:canSeePoint(x, y)
  local w, h = self:getDimensions()
  local x_off = math.ceil(w / 2)
  local y_off = math.ceil(h / 2)

  local x0, y0 = self.pos:getX(), self.pos:getY()

  local x_min, x_max = x0 - x_off, x0 + x_off
  local y_min, y_max = y0 - y_off, y0 + y_off

  return (x >= x_min and x <= x_max and y >= y_min and y <= y_max)
end


function Camera:canSeeRange(x, y, w, h)
  local obj_rect = Rect(x, y, w, h)

  local cam_w, cam_h = self:getDimensions()
  local cam_rect = Rect(self.pos:getX() - math.ceil(cam_w / 2), 
                        self.pos:getY()   - math.ceil(cam_h /2), 
                        cam_w, cam_h
                       )
  return obj_rect:intersects(cam_rect)
end


function Camera:canSee(e)
  local x, y = e.position:getX(), e.position:getY()
  if e.width or e.height then 
    return self:canSeeRange(x, y, e.width, e.height)
  end

  return self:canSeePoint(x, y)
end


setmetatable(Camera, {__call = function(_, ...) return new(...) end})

return Camera
