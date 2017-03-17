local Vector = require('vec2')

local Position = {}
Position.__index = Position


local function new(x, y, location, ori)
  return setmetatable({
      _local = Vector(x or -1, y or -1),
      ori = ori or 0,
      location = location or nil
    }, Position)
end


function Position:set(x, y, location)
  self._local = Vector(x, y)
  if location then self.location = location end
end


function Position:move(dx, dy)
  self._local = self._local + Vector(dx, dy)
end


function Position:get()
  return self._local:clone()
end


function Position:getX()
  return self._local.x
end


function Position:getY()
  return self._local.y
end


function Position:update(delta)
  self._local = self._local + delta
end


function Position:setOri(d)
  assert(type(d) == 'number')
  self.ori = d
end


-- TODO: Not finished yet.
-- function Position:rotate(d)
--   local r = utils.degreeToRad(d)
-- end

function Position:setLocation(parent)
  self.location = parent
end


function Position:hasParent()
  return self.location ~= nil or 'screen'
end


function Position:getParentPos()
  return self.location.position
end


function Position:getRoot()
  local parent = self:getParentPos()
  repeat 
    if not parent.location then
      return parent
    end
    parent = parent:getParentPos()
  until not parent
end


function Position:getActual(max)
  local pos = self._local:clone()
  local parent = self.location

  local cur_lvl = 1
  while parent and cur_lvl ~= max do
    assert(parent.position, "Trying to open invalid position component!")
    pos = pos + parent.position._local
    parent = parent.location
    cur_lvl = cur_lvl + 1
  end

  return pos
end


function Position:isActive()
  return self._local == Vector(-1, -1)
end


local function basic_getPos(e)
  return e.position._local
end


local function actual_getPos(e)
  return e.position:getActual()
end

Position.func_t = {
  actual = actual_getPos,
  basic = basic_getPos
}

setmetatable(Position, {__call = function(_, ...) return new(...) end})

return Position
