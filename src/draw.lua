local Animation = require('component.animation')
local Vector    = require('math.vec2')
local Rect      = require('geometry.rect')

local lg = love.graphics

local Draw = {}
Draw.__index = Draw

function Draw.animatedSprite(v, x, y)
  v.animation.cur:draw(v.img, x, y)
end

function Draw.static(v, x, y)
  lg.draw(v.img, v.sprite, x, y)
end

function Draw.map(x, y)
  return
end

function Draw.box(x, y, w, h)
  local box = Rect(x, y, w, h)
  box:drawBorder()
end

function Draw.mapNode(node, map_x, map_y)
  Draw.box(map_x + ((node:getX()) * 32), map_y + ((node:getY()) * 32), 32, 32)
end



return Draw

