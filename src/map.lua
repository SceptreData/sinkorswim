local Grid = require('lib/jumper.grid')
local Pathfinder = require('lib/jumper.pathfinder')


local Rect = require('rect')
local Vector = require('vec2')


local Map = {}

function Map:new (data, walkable, algorithm)
  local m = {}
  m.grid = Grid(data)
  m.width, m.height = m.grid:getWidth(), m.grid:getHeight()
  m.pathfinder = Pathfinder (m.grid, walkable or '0', algorithm or 'JPS')

  self.__index = self 
  return setmetatable(m, self)
end


function Map:getPath(x0, y0, x1, y1)
  if type(x0) == 'cdata' and type(y0) == 'cdata' then
    return self.pathfinder:getPath(x0.x, x0.y, y0.x, y0.y)
  end
  return self.pathfinder:getPath(x0, y0, x1, y1)
end


return Map
-- function Map:draw()
--   local w, h = self.grid:getWidth(), self.grid:getHeight()
--   for j = 0, h - 1 do
--     for i = 0, w - 1 do
--       local cell = Rect(self.position.x + (i * self.tile_size), self.position.y + (j * self.tile_size), self.tile_size, self.tile_size)
--       if self.grid:isWalkableAt(i + 1, j + 1, '0') then
--         cell:drawBorder()
--       else
--         cell:fill()
--       end
--     end
--   end
-- end
--
-- function Map:drawPath(path)
--   local p_img = Atlas.prop.debugBox.img
--   local q = Atlas.prop.debugBox.frames[2]
--   if path then
--     for node, count in path:iter() do
--       print("Node Info:", node.x, node.y, count)
--       love.graphics.draw(p_img, q, self.position.x + ((node.x) * self.tile_size), self.position.y + ((node.y) * self.tile_size))
--     end
--   end
-- end
--
--
