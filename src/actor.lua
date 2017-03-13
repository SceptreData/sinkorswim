-- Actor factory
local Animation = require('animation')
local Collision = require('collision')
local Movement = require('movement')
local Rect = require('rect')
local Vector = require('vec2')

local Actor = {}
Actor.__index = Actor

function Actor.new(id,x, y, state, dir)
  local data = Atlas.actor[id]
  local a = setmetatable({}, Actor)
  a.id = id
  a.img = data.img
  a.box_w, a.box_h = data.sw, data.sh
  a.animation = Animation.attach(data.anim)

  a.position =  Vector(x or 0, y or 0)
  a.velocity = Vector(0, 0)
  a.acceleration = 0
  a.is_solid = true

  a.state = state or 'idle'
  a.dir = dir or 'down'
  a.maxSpeed = 100

  -- Debug Options
  a.drawBox = true

  return a
end

function Actor:changeDir(dir)
  if dir == self.dir then return end
  self.dir = dir
  self.animation:flag()
end

function Actor:changeState(state)
  if state == self.state then return end
  self.state = state
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

-- TODO: Re work this into /visual component
function Actor:draw()
  if self.drawBox == true then
    local box = Rect(self.position.x, self.position.y, self.box_w, self.box_h)
    box:drawBorder()
  end
  self.animation.cur:draw(self.img, self.position.x, self.position.y)
end

setmetatable(Actor, {__call = function(_, ...) return Actor.new(...) end})

return Actor
