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
local Vector = require('math.vec2')
local Visual = require('visual')
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
  b.cell_size = 32
  b.width, b.height = b.map:getWidth(), b.map:getHeight()

  b.visual = Visual({
    id = 'map', 
    w = cell_size,
    h = cell_size
  })

  b.crew = {}
  b.objects = {}
  b.status = 'pre_init'

  self.__index = self
  return setmetatable(b, self)
end


-- this function takes a string as first arg.
function Boat:attach (e_type, e)
  local t = self[e_type]
  assert(t, "trying to add entity to invalid boat container")
  t[#t + 1] = e
  e.position.location = self

  if self.status == 'active' then
    Game:add(e)
  end
end


function Boat:init(x, y, location)
  self.position:set(x or -1, y or -1, location or nil)
  Game:add(self)
  for i = 1, #self.objects do
    Game:add(self.objects[i])
  end
  for i = 1, #self.crew do
    Game:add(self.crew[i])
  end
  self.status = 'active'
end


function Boat:getHomeless()
  local shelter = {}
  for i = 1, #self.crew do
    local bum = self.crew[i]
    if not bum.position:isActive() then
      shelter[#shelter + 1] = bum
    end
  end
  return shelter
end


setmetatable(Boat, {__call = function(_, ...) return Boat:new(...) end})
    
return Boat
