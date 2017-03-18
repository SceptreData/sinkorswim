local Grid       = require('lib/jumper.grid')
local Pathfinder = require('lib/jumper.pathfinder')
local Vector     = require('math.vec2')

local isVec2  = Vector.isVector

local DEFAULT = {
  pathFunc = function(v) return v ~= '#' end,
  alg = 'ASTAR'
}

local Map = {}

function Map:new (map_data, alg, path_func, mode)
  local m = {}
  m._grid = Grid(map_data)
  m._pathfinder = Pathfinder(m._grid, alg or DEFAULT.alg, path_func or DEFAULT.pathFunc)
  if mode then m._pathfinder:setMode(mode) end

  self.__index = self 
  return setmetatable(m, self)
end


function Map:notBlockedAt (x, y, f)
  assert(self:inBounds(x, y), "Trying to access out of bounds grid cell")
  return self._grid:isWalkableAt(x, y, f or DEFAULT.pathFunc)
end



function Map:getPath(x0, y0, x1, y1)
  if isVector(x0) and isVector(y0) then
    x0, y0, x1, y1 = x0.x, x0.y, y0.x, y0.y
  end
  return self._pathfinder:getPath(x0, y0, x1, y1)
end

function Map:getCell(x, y)
  return self._grid._map[y][x]
end

function Map:getNode(x, y)
  return self._grid:getNodeAt(x, y)
end

-- TODO: Move this logic somewhere else, movement system?
function Map:getDirection(origin, target)
  return (target - prev):normalize()
end


function Map:each(f, ...)
  for node in self._grid:iter() do
    f(node, ...)
  end
  return self
end


function Map:eachRange(f, x0, y0, x1, y1, ...)
  if isVec2(x0) and isVec2(y0) then
    x0, y0, x1, y1 = x0.x, x0.y, y0.x, y0.y
  end

  for node in self._grid:iter(x0, y0, x1, y1) do
    f(node, ...)
  end
  return self
end


function Map:map(f, ...)
  for node in self._grid:iter() do
    node = f(node, ...)
  end
  return self
end


function Map:mapRange(x0, y0, x1, y1, f, ...)
  for node in self._grid:iter(x0,y0,x1,y1) do
    node = f(node, ...)
  end
  return self
end


function Map:getDimensions()
  return self._grid:getWidth(), self._grid:getHeight()
end


function Map:getWidth()
  return self._grid:getWidth()
end


function Map:getHeight()
  return self._grid:getHeight()
end


function Map:getBounds()
  return self._grid:getBounds()
end

function Map:inBounds(x, y)
  if type(x) == 'cdata' then
    x, y = x.x, x.y
  end
  return not (x < 0 or x > self._grid:getWidth()
         or y < 0 or y > self._grid:getHeight())
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
