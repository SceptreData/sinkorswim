--  Rectangle Functions
local ffi    = require('ffi')
local Vector = require('math.vec2')

local lg = love.graphics

ffi.cdef[[
  typedef struct {
    double x, y, w, h;
  } rect_t;
]]

local new = ffi.typeof('rect_t')

local Rect = {}

function Rect.isRect(a)
  return ffi.istype('rect_t')
end

function Rect.new(x, y, w, h)
  if x and y and w and h then
    return new(x, y, w, h)
  end

  return new()
end

function Rect:clone(a)
  return new(self.x, self.y, self.w, self.h)
end

function Rect.intersects(a, b)
  return (a.x <= b.x + b.w and
          b.x <= a.x + a.w and
          a.y <= b.y + b.h and
          b.y <= a.y + a.h)
end

function Rect.drawBorder(a)
  lg.rectangle('line', a.x, a.y, a.w, a.h)
end

function Rect.fill(a)
  lg.rectangle('fill', a.x, a.y, a.w, a.h)
end

function Rect.toString(a)
  return 'RECT: ' .. a.x .. ', ' .. a.y .. ': ' .. a.w .. ', ' .. a.h
end

local Rect_mt = {}
Rect_mt.__index = Rect

Rect_mt.__call = function(_, x, y, w, h) return Rect.new(x, y, w, h) end

Rect_mt.__eq = function(a, b)
  if not Rect.isRect(a) or not Rect2.isRect(b) then return false end
  return (a.x == b.x and
          a.y == b.y and
          a.w == b.w and
          a.h == b.h)
end

Rect_mt.__tostring = Rect.toString

ffi.metatype(new, Rect_mt)

return setmetatable({}, Rect_mt)
