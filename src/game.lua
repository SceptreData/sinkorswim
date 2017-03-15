local tiny = require('lib/tiny')

local Animation = require('animation')
local Movement = require('movement')
local Visual = require('visual')

local Game = {}
Game.__index = Game

Game.world = 0

local start_time = 0
local num_ticks = 0
local num_ents = 0


function Game:new()
  start_time = love.timer.getTime()
  self.world = tiny.world()
  self:initSystems()
end


function Game:initSystems()
  self.world:addSystem(Movement.system)
  self.world:addSystem(Animation.system)

  self.world:addSystem(Visual.system)
  Visual.system.active = false
end


function Game:add(e)
  self.world:addEntity(e)
  num_ents = num_ents + 1
end


function Game:update(dt)
  self.world:update(dt)
  num_ticks = num_ticks + 1
end

return Game
