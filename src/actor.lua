-- Actor factory
local Animation = require('component.animation')
local Collision = require('component.collision')
local Visual    = require('component.visual')

local Movement = require('movement')
local Position = require('component.position')
local Map      = require('component.map')

local Rect   = require('geometry.rect')
local Vector = require('math.vec2')
local utils  = require('utils')

local Actor = {}
Actor.__index = Actor

function Actor.new(id)
  local data = Atlas.actor[id]
  assert(data, "failed to load Actor: %s", id)

  local a = setmetatable({}, Actor)
  a.id = id
  a.position = Position()
  a.velocity = Vector(0, 0)
  a.acceleration = 0
  a.is_solid  = true

  a.state = 'inactive'
  a.maxSpeed = 100

  a.visual = Visual({
    id   = 'animatedSprite',
    img  = data.img,
    w    = data.sw,
    h    = data.sh,
    anim = data.anim,
  })
  
  return a
end


function Actor:place(x, y, location)
  local target = location or self.position.location
  local map = target.map

  if map then
    assert(map:notBlockedAt(x, y))
  end
    
  self.position:set(x, y, location or nil)
end


function Actor:setDir(dir)
  if type(dir) == 'number' then
    dir = utils.degreeToRadian(dir)
  else dir = Movement[dir] end

  self.position.ori = dir
  self.animation:flag()
end


function Actor:setState(s)
  if s == self.state then return end
  self.state = s
  self.animation:flag()
end


function Actor:isMoving()
  return not self.velocity:isZero()
end


function Actor:stopMovement()
  self.velocity = Vector(0,0)
  self.acceleration = 0
end


function Actor:move (dir, speed)
  if self.dir ~= dir then
    -- Cancel out motion and make unit stop first.
    if self:isMoving() then
      self:stopMovement()
      self.state = 'idle'
      self.animation:flag()
      return
    end
    self.dir = dir
  end
  self.acceleration = self.acceleration + speed
  self.state = 'walking'
  self.animation:flag()
end


setmetatable(Actor, {__call = function(_, ...) return Actor.new(...) end})

return Actor
