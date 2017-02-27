local tiny = require('lib/tiny')

local Animation = require('animation')
local Movement = require('movement')

local Game = {}
Game.__index = Game

Game.start_time = 0

function Game:new()
  self.start_time = love.timer.getTime()
  self.world = tiny.world()
  self:initSystems()
  return self.world
end

function Game:initSystems()
  self.world:add (Movement.system, Animation.system)
end

return Game
