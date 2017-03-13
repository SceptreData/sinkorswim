-- Ship
--     Layout?
--     Defaults?
--     Resources
-- *   Map
-- *   Movement
-- *   location
--     Status
--     Visual (Probably should be rendered first?)

local Vector = require('vec2')
local Map = require('map')

local Boat = {}

function Boat:new (id, pos )
  local data = Atlas.boat[id]
  assert(data)

  local b = {}
  b.id = id
  b.position = pos or nil

  b.map = Map:new(data.map_data)
  b.map._pathfinder:setMode('ORTHOGONAL')

  b.crew = {}
  self.__index = self
  return setmetatable(b, self)
end


function Boat:add (ent)
  table.insert(self.crew, ent)
  ent.location = self
end
  
return Boat
