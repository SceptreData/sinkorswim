local Grid = require('lib/jumper.grid')
local Pathfinder = require('lib/jumper.pathfinder')

local Rect = require('rect')
local Vector = require('vec2')


local Map = {}

function Map:new(map_str, x, y, walkable, tile_size)
    local m = {}
    m.position = Vector(x or 0, y or 0)
    m.grid = Grid(map_str)
    m.pathfinder = Pathfinder(m.grid, 'JPS', walkable or 0)
    m.tile_size = tile_size or 32
    
    self.__index = self
    return setmetatable(m, self)
end

function Map:draw()
  local w, h = self.grid:getWidth(), self.grid:getHeight()
  for j = 0, h - 1 do
    for i = 0, w - 1 do
      local cell = Rect(self.position.x + (i * self.tile_size), self.position.y + (j * self.tile_size), self.tile_size, self.tile_size)
      if self.grid:isWalkableAt(i + 1, j + 1, '0') then
        cell:drawBorder()
      else
        cell:fill()
      end
    end
  end
end

function Map:getPath(x0, y0, x1, y1)
  return self.pathfinder:getPath(x0, y0, x1, y1)
end

function Map:drawPath(path)
  local p_img = Atlas.prop.debugBox.img
  local q = Atlas.prop.debugBox.frames[2]
  if path then
    for node, count in path:iter() do
      print("Node Info:", node.x, node.y, count)
      love.graphics.draw(p_img, q, self.position.x + ((node.x) * self.tile_size), self.position.y + ((node.y) * self.tile_size))
    end
  end
end

return Map
