local lume = require('lib/lume')
local json = require('lib/json')
local anim8 = require('lib/anim8')

local Animation = require('animation')
local utils = require('utils')

local lg = love.graphics


local Atlas = {}
Atlas.__index = Atlas

Atlas.actor = {}
Atlas.prop = {}

function Atlas:add(path)
  local o = utils.loadJSON(path)
  local entry = {}
  if o.img then
    entry.img = lg.newImage('assets/' .. o.img)
    entry.img:setFilter('nearest', 'nearest')
  end

  if o.sheet then
    local sw, sh = getSpriteDimensions(entry.img, o.sheet)
    if o.animations then
      entry.anim = Animation.build(entry.img, o.animations, sw, sh)
    else
      entry.frames = buildStaticSheet(entry.img, o.sheet, sw, sh)
    end
    entry.sw, entry.sh = sw, sh
  end

  self[o.category][o.id] = entry
end

function buildStaticSheet(img, sheet, sw, sh)
  local img_w, img_h = img:getDimensions()
  local frames = {}
  print("rows:", sheet.rows, "cols:", sheet.cols)
  for y = 0, sheet.rows - 1 do
    for x = 0, sheet.cols - 1 do
        local q = love.graphics.newQuad(x * sw, y * sh, sw, sh, img_w, img_h )
        table.insert(frames, q)
      end
    end
  print(#frames)
  return frames
end

function getSpriteDimensions(img, sheet_info)
  local img_w, img_h = img:getDimensions()
  local sprite_w = img_w / sheet_info.cols
  local sprite_h = img_h / sheet_info.rows

  return sprite_w, sprite_h
end
 

function Atlas:listAnim(category, id)
    for state, state_table in pairs(self[category][id]) do
      for sub, _ in pairs(state_table) do
        print(state, sub)
      end
    end
end

return Atlas
