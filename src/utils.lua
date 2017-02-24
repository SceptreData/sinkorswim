local lume = require('lib/lume')
local json = require('lib/json')

local utils = {}

function utils.getFileNames(files)
  local t = {}
  for _, file in ipairs(files) do
    local name = lume.split(file, '.')
    table.insert(t, name[1])
  end
  return t
end

function utils.loadJSON(path)
  local contents, _ = love.filesystem.read(path)
  return json.decode(contents)
end


function buildAnimationTable(img, raw_obj)
  local anim_t = {}
  local spr_w, spr_h = getSpriteDimensions(img, raw_obj.sheet)

  local grid = anim8.newGrid(spr_w, spr_h, img:getWidth(), img:getHeight())

  for idx, _ in ipairs(raw_obj.animations) do
    local state = raw_obj.animations[idx]
    if anim_t[state.id] == nil then anim_t[state.id] = {} end

    for k, frame_range in pairs(state.frames) do
      anim_t[state.id][k] = anim8.newAnimation(grid(unpack(frame_range), state.timing))
    end
  end

  return anim_t
end

function newAtlasEntry (atlas, path)
  local obj = loadJSON (path)

  local entry = {}
  entry.img = love.graphics.newImage(obj.img_path)

  if obj.sheet then
    local sprite_w, sprite_h = getSpriteDimensions(entry.img, obj.sheet)
    if obj.animations then
      entry.animations = buildAnimationTable(entry.img, obj)
    else
      entry.contents = buildSpriteTable(entry.img, obj)
    end
  end

  atlas[obj.category][obj.id] = entry
end

return utils
