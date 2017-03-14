-- Movement Systems
local tiny = require('lib/tiny')

local utils = require('utils')
local Vector = require('vec2')

local cos, sin = math.cos, math.sin

local Movement = {}
Movement.__index = Movement

Movement.north = utils.degreeToRadian(180)
Movement.east =  utils.degreeToRadian(90)
Movement.south = utils.degreeToRadian(0)
Movement.west = utils.degreeToRadian(270)

Movement.up = Movement.north
Movement.right = Movement.east
Movement.down = Movement.south
Movement.left = Movement.west

function Movement.getDir(d)
  if type(d) == 'number' then
    return utils.degreeToRadian(d)
  end

  return Movement[d]
end

local function calculateVelocity (v, r, accel)
  local dv = Vector(sin(r) * accel, cos(r) * accel)
  return v:add(dv)
end

Movement.system = tiny.processingSystem()
Movement.system.filter = tiny.requireAll("position", "velocity", "acceleration")
function Movement.system:process(e, dt)
  local r = e.orientation or Movement[e.dir]
  e.velocity = calculateVelocity (e.velocity, r, e.acceleration)

  local max = e.maxSpeed or 100
  if math.abs(e.velocity.x) > max then
    local mod = e.velocity.x >= 0 and 1 or -1
    e.velocity.x = max * mod
  end

  if math.abs(e.velocity.y) > max then
    local mod = e.velocity.y >= 0 and 1 or -1
    e.velocity.y = max * mod
  end

  e.position = e.position + (e.velocity * dt)
end
  
return Movement
