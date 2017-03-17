love.filesystem.setRequirePath('?.lua;src/?.lua;')

local anim8 = require('lib/anim8')
local json = require('lib/json')
local lume = require('lib/lume')
local tiny = require('lib/tiny')

Log = require('lib/log')

Atlas  = require('atlas')
Game   = require('game')
Window = require('window')

local Actor    = require('actor')
local Boat     = require('boat')
local Movement = require('movement')
local Prop     = require('prop')

local Animation = require('component.animation')
local Collision = require('component.collision')
local Map       = require('component.map')
local Visual    = require('component.visual')

local fs = love.filesystem
local lg = love.graphics


local sailor, green_box, world, _map, path, sub

function love.load()
  Window:init()

  Atlas:add('data/sailor.json')
  Atlas:add('data/redgreen.json')
  Atlas:add('data/grid_ship.json')

  Game:new()

  sub = Boat:new('grid_ship')
  sailor = Actor('sailor')
  green_box = Prop('debugBox', 2, true)

  sub:attach('crew', sailor)
  sub:attach('objects', green_box)
  sailor:place(2, 2)
  green_box:place(3, 3)
  
  sub:init(10, 10)
  Game.cam:lookAt(sub)

end

-- TODO
-- Collison Checking
-- Reimplmenting Animations
function love.update(dt)
  Game:update(dt)
end

function love.draw()
  lg.setColor(255, 255, 255)
  Visual.system:update()
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
end

--   if k == 'left' then sailor:move('left', 10)
--   elseif k == 'right' then sailor:move('right', 10)
--   elseif k == 'up' then sailor:move('up', 10)
--   elseif k == 'down' then sailor:move('down', 10)
--   elseif k == 'u' then sailor:changeState('working')
--   elseif k == 'w' then sailor:changeState('walking')
--   end
