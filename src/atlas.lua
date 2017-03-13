local lume = require('lib/lume')
local json = require('lib/json')
local anim8 = require('lib/anim8')

local Animation = require('animation')
local utils = require('utils')

local lg = love.graphics
local fs = love.filesystem


local Atlas = {}
Atlas.__index = Atlas

Atlas.actor = {}
Atlas.boat= {}
Atlas.prop = {}


local function load_LuaAsset(path)
  assert(fs.exists('assets/' .. path))
  return dofile('assets/' .. path)
end


local function buildDefaults (data)
  local defaults = {}

  for category, arr in pairs(data) do
    local objs = {}

    for i = 1, #arr do
      local entry = lume.split(arr[i])
      assert(#entry > 0)
      local id = entry[1]
      local num = tonumber(entry[2]) or 1

      objs[id] = num
    end

    defaults[category] = objs
  end

  return defaults
end


local function buildStaticSheet(img, sheet, sw, sh)
  local img_w, img_h = img:getDimensions()
  local frames = {}
  for y = 0, sheet.rows - 1 do
    for x = 0, sheet.cols - 1 do
        local q = love.graphics.newQuad(x * sw, y * sh, sw, sh, img_w, img_h )
        table.insert(frames, q)
      end
    end
  return frames
end


local function getSpriteDimensions(img, sheet_info)
  local img_w, img_h = img:getDimensions()
  local sprite_w = img_w / sheet_info.cols
  local sprite_h = img_h / sheet_info.rows

  return sprite_w, sprite_h
end
 

function Atlas:add(path)
  local asset = utils.loadJSON(path)
  
  local entry = {
    name     = asset.name or asset.id,
    details  = asset.details or nil,
    defaults = asset.defaults and buildDefaults(asset.defaults) or nil,
  }

  if asset.img then
    entry.img = lg.newImage('assets/' .. asset.img)
    entry.img:setFilter('nearest', 'nearest')
  end

  if asset.sheet then
    local sw, sh = getSpriteDimensions(entry.img, asset.sheet)
    if asset.animations then
      entry.anim = Animation.build(entry.img, asset.animations, sw, sh)
    else
      entry.frames = buildStaticSheet(entry.img, asset.sheet, sw, sh)
    end
    entry.sw, entry.sh = sw, sh
  end

  -- TODO: Get rid of this LuaAsset call
  if asset.map then
    entry.map_data = load_LuaAsset(asset.map)
  end

  self[asset.category][asset.id] = entry
end

function Atlas:listAnim(category, id)
    for state, state_table in pairs(self[category][id]) do
      for sub, _ in pairs(state_table) do
        print(state, sub)
      end
    end
end

return Atlas
