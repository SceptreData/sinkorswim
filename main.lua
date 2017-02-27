love.filesystem.setRequirePath('?.lua;src/?.lua;')

local anim8 = require('lib/anim8')
local lume = require('lib/lume')
local json = require('lib/json')
local tiny = require('lib/tiny')

local fs = love.filesystem
local lg = love.graphics

Atlas = require('atlas')
Game = require('game')
Window = require('window')

local Actor = require('actor')
local Animation = require('animation')
local Collision = require('collision')
local Movement = require('movement')
local Prop = require('prop')

local sailor, green_box, world

function love.load()
  Window.init()
  Atlas:add('data/sailor.json')
  Atlas:add('data/redgreen.json')

  world = Game:new()

  sailor = Actor('sailor', Window.screen_w/2, Window.screen_h/2)
  green_box = Prop('debugBox', 2, 300, 300, true)
  
  world:addEntity(sailor)
  world:addEntity(green_box)
  print(sailor.animation.cur:getDimensions())
end


function love.update(dt)
  world:update(dt)
  if Collision.checkBox(sailor, green_box) then
    love.window.showMessageBox("Collision!", "Objects have collided!", 'info')
  end
end

function love.draw()
  lg.setColor(255, 255, 255)
  green_box:draw()
  sailor:draw()
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
