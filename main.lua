love.filesystem.setRequirePath('?.lua;src/?.lua;')

local anim8 = require('lib/anim8')
local lume = require('lib/lume')
local json = require('lib/json')
local tiny = require('lib/tiny')

local fs = love.filesystem
local lg = love.graphics

Atlas = require('atlas')
Animation = require('animation')

local scr_w, scr_h

-- TODO: Following functions should be worked into an Actor component
function newActor(id, x, y, state, dir)
  local data = Atlas.actor[id]
  local a = {}
  a.id = id
  a.x, a.y = x or scr_w/2, y or scr_h/2
  a.state = state or 'idle'

  a.dir = dir or 'south' 
  a.img = data.img
  a.animation = Animation.attach(data.anim)

  return a
end

function changeDir(a, dir)
  if dir == a.dir then return end
  a.dir = dir
  a.animation:flag()
end

function changeState(a, state)
  if state == a.state then return end
  a.state = state
  a.animation:flag()
end
-----------------------------------------------

local sailor, world

function love.load()
  start = love.timer.getTime()
  scr_w, scr_h = lg.getDimensions()
  Atlas:add('data/sailor.json')

  sailor = newActor('sailor')

  world = tiny.world(Animation.system, sailor)
end


function love.update(dt)
  world:update(dt)
end

function love.draw()
  lg.setColor(255, 255, 255)
  lg.scale(1.5)
  sailor.animation.cur:draw(sailor.img, sailor.x, sailor.y)
end

function love.keypressed(k)
  if k == 'escape' then
    love.event.quit()
  end
  if k == 'left' then changeDir(sailor, 'west')
  elseif k == 'right' then changeDir(sailor, 'east')
  elseif k == 'up' then changeDir(sailor, 'north')
  elseif k == 'down' then changeDir(sailor, 'south')
  elseif k == 'u' then changeState(sailor, 'working')
  elseif k == 'w' then changeState(sailor, 'walking')
  end
end
