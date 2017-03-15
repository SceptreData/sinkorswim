-- Ship
--     Layout?
--     Defaults?
--     Resources
-- *   Map
-- *   Movement
-- *   location
--     Status
--     Visual (Probably should be rendered first?)
local Position = require('position')
local Vector = require('vec2')
local Map = require('map')

local Boat = {}

function Boat:new (id)
  local data = Atlas.boat[id]
  assert(data)

  local b = {}
  b.id = id
  b.position = Position()

  b.map = Map:new(data.map_data)
  b.map._pathfinder:setMode('ORTHOGONAL')

  b.crew = {}
  b.objs = {}
  b.status = 'pre_init'

  self.__index = self
  return setmetatable(b, self)
end


function Boat:initAt(x, y, location)
  self.position:set(x or -1, y or -1, location or nil)
  Game:add(self)
  for i = 1, #self.crew do
    Game:add(self.crew[i])
  end
  for i = 1, #self.objs[i] do
    Game:add(self.objs[i])
  end
  self.status = 'active'
end

-- this function takes a string as first arg.
function Boat:add (e_type, e)
  local t = self[e_type]
  assert(t, "trying to add entity to invalid boat container")
  t[#t + 1] = e
  e.position.location = self

  if self.status == 'active' then
    Game:add(e)
  end
end


setmetatable(Boat, {__call = function(_, ...) return Boat:new(...) end})
    
return Boat
