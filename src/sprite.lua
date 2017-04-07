local utils = require('utils') 

local Tile = require('tile')

local mapArray = utils.mapArrayVals
local lg = love.graphics

local Sprite = {}
Sprite.__index = Sprite

local SPRITE_RULES = {
  wall = function(map, x, y)
    if x == 1 and y == 1 then return 6
    elseif x == map:getWidth() and y == 1 then return 3
    elseif x == 1 and y == map:getHeight() then return 5
    elseif x == map:getWidth() and y == map:getHeight() then return 4
    elseif (x == 1 or x == map:getWidth()) and y > 1 then return 2
    else return 1
    end
  end,

  floor = function()
    if math.random(10) == 1 then return 2
    else return 1
    end
  end
}

function Sprite.newStatic(img, sheet, sw, sh)
  local img_w, img_h = img:getDimensions()
  local sprites = {}
  for y = 0, sheet.height - 1 do
    for x = 0, sheet.width - 1 do
        local q = lg.newQuad(x * sw, y * sh, sw, sh, img_w, img_h )
        table.insert(sprites, q)
     end
   end
  sprites.sprite_map  = sheet.ids and mapArray(sheet.ids) or nil
  return sprites 
end

function Sprite.mapGet(atl_group, sprite_id)
  assert(type(atl_group) == 'string')
  local spr_t = Atlas[atl_group].sprites
  assert(spr_t, "error loading sprite_table")
  local idx = spr_t.sprite_map[sprite_id]
  assert(idx, "invalid sprite_id!")

  return spr_t[idx]
end

function Sprite.buildSpriteMap(atl_group, map)
  local tile_group = Tile.getGroup(atl_group)
  assert(tile_group, atl_group)
  local s_map = {}
  for j = 1, map:getHeight() do
    s_map[j] = {}
    for i = 1, map:getWidth() do
      local c = map:getCell(i, j)
      local tile = tile_group[tile_group._map[c]]
      local rule = SPRITE_RULES[tile.spr_sheet.rule] or nil
      if rule then table.insert(s_map[j], rule(map, i, j))
      else table.insert(s_map[j], 1) end
    end
  end
  return s_map
end


function Sprite.getDimensions(img, spr_sheet)
  local img_w, img_h = img:getDimensions()
  local sprite_w = img_w / spr_sheet.width
  local sprite_h = img_h / spr_sheet.height

  return sprite_w, sprite_h
end

return Sprite
