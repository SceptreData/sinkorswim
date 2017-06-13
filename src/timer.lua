local getTime = love.timer.getTime

local Timer = {}
Timer.__index = Timer

local function new(ticks)
  return setmetatable({
    start = 0,
    ticks  = ticks or 0,
    active = false
  }, Timer)
end

local function add_timer(a, b)
  return new(a.ticks + b.ticks)
end

local function sub_timer(a, b)
  return new(a.ticks - b.ticks)
end

function Timer:start()
  assert(not self.active)
  self.start = getTime()
  self.active = true
end

function Timer:stop()
  assert(self.active)
  self.ticks = self.ticks + (getTime() - self.start)
  self.active = false
end

function Timer:clear()
  self.ticks = 0
end

function Timer:getSeconds()
  assert(not self.active)
  return self.ticks
end

function Timer:getMs()
  assert(not self.active)
  return self.ticks * 1000
end


setmetatable(Timer, {
  __call = function (_, ticks) return new(ticks) end,
  __add = add_timer,
  __sub = sub_timer,
})

return Timer
