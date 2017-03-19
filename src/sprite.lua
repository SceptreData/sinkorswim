local utils = require('utils') 

local mapArray = utils.mapArrayVals
local lg = love.graphics

local Sprite = {}
Sprite.__index = Sprite

function Sprite.newStatic(img, sheet, sw, sh)
  local img_w, img_h = img:getDimensions()
  local sprites = {}
  for y = 0, sheet.rows - 1 do
    for x = 0, sheet.cols - 1 do
        local q = lg.newQuad(x * sw, y * sh, sw, sh, img_w, img_h )
        table.insert(sprites, q)
     end
   end
  sprites.sprite_map  = sheet.ids and mapArray(sheet.ids) or nil
  return sprites 
end

function Sprite.mapGet(atlas_id, sprite_id)
  local spr_t = Atlas.static[atlas_id].frames
  assert(spr_t, "error loading sprite_table")
  assert(spr_t.sprite_map, "Sprite table '" .. atlas_id .."' has no sprite map")
  local idx = spr_t.sprite_map[sprite_id]
  assert(idx, "invalid sprite_id!")

  return spr_t[idx]
end

function Sprite.getDimensions(img, sheet_info)
  local img_w, img_h = img:getDimensions()
  local sprite_w = img_w / sheet_info.cols
  local sprite_h = img_h / sheet_info.rows

  return sprite_w, sprite_h
end

return Sprite
