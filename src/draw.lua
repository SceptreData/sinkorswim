local Tile      = require('tile')
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


function Draw.map(v, x, y)
    for j = 1, v.map:getHeight() do
      for i = 1, v.map:getWidth() do
        local c = v.map:getCell(i, j)
        local tile = Tile.getTileFrom(v.t_group, c)
        local spr_idx = v.spr_map[j][i]
        local q = tile.sprites[spr_idx]
        lg.draw(tile.img, q, x + (i * 32), y + (j * 32))
      end
    end
end


function Draw.box(x, y, w, h)
  local box = Rect(x, y, w, h)
  box:drawBorder()
end


function Draw.mapNode(node, map_x, map_y)
  Draw.box(map_x + ((node:getX()) * 32), map_y + ((node:getY()) * 32), 32, 32)
end


return Draw
