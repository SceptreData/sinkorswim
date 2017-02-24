local lume = require('lib/lume')
local json = require('lib/json')
local anim8 = require('lib/anim8')

local lg = love.graphics

local Animation = require('animation')

local Atlas = {}
Atlas.__index = Atlas

Atlas.actor = {}

function loadJSON(path)
  local contents, _ = love.filesystem.read(path)
  return json.decode(contents)
end


function Atlas:add(path)
  local o = loadJSON(path)
  local entry = {}
  if o.img then
    entry.img = lg.newImage('assets/' .. o.img)
    entry.img:setFilter('nearest', 'nearest')
  end

  if o.sheet then
    local sw, sh = getSpriteDimensions(entry.img, o.sheet)
    if o.animations then
      entry.anim = Animation.build(entry.img, o.animations, sw, sh)
    end
  end

  self[o.category][o.id] = entry
end

function getSpriteDimensions(img, sheet_info)
  local img_w, img_h = img:getDimensions()
  local sprite_w = img_w / sheet_info.cols
  local sprite_h = img_h / sheet_info.rows

  return sprite_w, sprite_h
end
 

function Atlas:listAnim(category, id)
    for k, _ in pairs(self[category][id]) do
      print(k)
    end
end

return Atlas
