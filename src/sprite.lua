local Sprite = {}
Sprite.__index = Sprite

function Sprite.newStatic(img, sheet, sw, sh)
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

function Sprite.getDimensions(img, sheet_info)
  local img_w, img_h = img:getDimensions()
  local sprite_w = img_w / sheet_info.cols
  local sprite_h = img_h / sheet_info.rows

  return sprite_w, sprite_h
end

return Sprite
