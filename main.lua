love.filesystem.setRequirePath('?.lua;src/?.lua;')

local anim8 = require('lib/anim8')
local json = require('lib/json')
local lume = require('lib/lume')
local tiny = require('lib/tiny')

Log = require('lib/log')

Atlas = require('atlas')
Game = require('game')
Window = require('window')

local Actor = require('actor')
local Animation = require('animation')
local Boat = require('boat')
local Collision = require('collision')
local Map = require('map')
local Movement = require('movement')
local Prop = require('prop')
local Visual = require('visual')

local fs = love.filesystem
local lg = love.graphics


local sailor, green_box, world, _map, path, sub

function love.load()
  Window.init()
  Atlas:add('data/sailor.json')
  Atlas:add('data/redgreen.json')
  Atlas:add('data/grid_ship.json')

  assert(Atlas.boat.grid_ship.map_data)

  Game:new()

  sub = Boat:new('grid_ship')
  sailor = Actor('sailor')

  --green_box = Prop('debugBox', 1, 300, 300, true)
  --world:addEntity(green_box)
end


function love.update(dt)
  Game:update(dt)
  -- if Collision.checkBox(sailor, green_box) then
  --   love.window.showMessageBox("Collision!", "Objects have collided!", 'info')
  -- end
end

function love.draw()
  lg.setColor(255, 255, 255)
  Visual.system:update()
  -- green_box:draw()
  -- sailor:draw()
  -- _map:draw()
  -- _map:drawPath(path)
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
  if k == 'left' then sailor:move('left', 10)
  elseif k == 'right' then sailor:move('right', 10)
  elseif k == 'up' then sailor:move('up', 10)
  elseif k == 'down' then sailor:move('down', 10)
  elseif k == 'u' then sailor:changeState('working')
  elseif k == 'w' then sailor:changeState('walking')
  end
end
