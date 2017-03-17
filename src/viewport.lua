local Rect = require('geometry.rect')
local Position = require('position')

local lg = love.graphics

local Viewport = {}
Viewport.__index = Viewport

local function new(x, y, w, h, parent)
  local vp = setmetatable({}, Viewport)
  -- Add checks for screen bounds
  vp.position = Position(x or 0, y or 0, parent or nil)
  vp.width = w or lg.getWidth()
  vp.height = h or lg.getHeight()

  vp.target = target or nil
  return vp
end

function Viewport:set(target)
  self.target = target
end

function Viewport:getWidth()
  return self.width
end

function Viewport:getHeight()
  return self.height
end

setmetatable(Viewport, {__call = function(_, ...) return new(...) end})

return Viewport
