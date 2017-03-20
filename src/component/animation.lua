-- Animation Component
local anim8 = require('lib/anim8')
local tiny  = require('lib/tiny')

local Animation   = {}
Animation.__index = Animation

function Animation.build(img, anim_data, spr_w, spr_h)
  local grid = anim8.newGrid(spr_w, spr_h, img:getWidth(), img:getHeight())

  local anim_t = {}
  for idx, _ in ipairs(anim_data) do
    local state = anim_data[idx]
    if anim_t[state.id] == nil then anim_t[state.id] = {} end

    for k, frame_range in pairs(state.frames) do
      anim_t[state.id][k] = anim8.newAnimation(grid(unpack(frame_range)), state.timing)
    end
  end

  return anim_t
end

function Animation.attach(animations)
  local a = setmetatable({}, Animation)

  for state, sub_state in pairs(animations) do
     a[state] = {}
     for key, anim in pairs(sub_state) do
       a[state][key] = anim:clone()
     end
  end
  a.flipped = false
  a.cur = a.idle.down or nil
  return a
end


function Animation:set(state, dir)
   local flip = false
   if dir == 'right' then
     flip = self.flipped
     dir = 'side'
   elseif dir == 'left' then
     if self.flipped == true then
       flip = false
     else
       flip = true
     end
     dir = 'side'
  end

  self.cur = self[state][dir]
  if flip == true  then
    self.cur:flipH()
    self.flipped = not self.flipped
  end
end


function Animation:update(dt)
    self.cur:update(dt)
end


Animation.system = tiny.processingSystem()
Animation.system.filter = tiny.requireAll('component.animation')
function Animation.system:process(e, dt)
  e.animation:update(e.state, e.dir, dt)
end

function Animation.listAnim(category, id)
    for state, state_table in pairs(Atlas[category][id]) do
      for sub, _ in pairs(state_table) do
        print(state, sub)
      end
    end
end

return Animation
