local lume = require('libs/lume')

function getFileNames(files)
  local t = {}
  for _, file in ipairs(files) do
    local name = lume.split(file, '.')
    table.insert(t, name[1])
  end
  return t
end

function loadJSON(path)
  local contents, _ = love.filesystem.read(path)
  return json.decode(contents)
end

function getSpriteDimensions(img, sheet_info)
  local img_w, img_h = img:getDimensions()
  local sprite_w = img_w / sheet_info.cols
  local sprite_h = img_h / sheet_info.rows

  return sprite_w, sprite_h
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
    
      

function buildImageObj(img_info)
  
  local o = {}
  if img.animated == true then
    obj = newAnimationObj( img, img_info)

    


function buildAnimationTable(obj)
  local ani_t = {}
  ani_t.img = love.graphics.newImage(obj.img.path

