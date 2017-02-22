package.path = package.path .. ";../?.lua"

local lume = require('lume')
local json = require('json')

function getFileNames(files)
  local t = {}
  for _, file in ipairs(files) do
    local name = lume.split(file, '.')
    table.insert(t, name[1])
  end
  return t
end

local img_atlas = { character = {}, fx = {} }

function LoadJSON(path)
  local contents, _ = love.filesystem.read(path)
  return json.decode(contents)
end

function BuildAtlas(data)
  for key, obj in pairs(data) do
    local entry = {}
    entry.img = love.graphics.newImage('assets/' .. obj.img)

    local img_w, img_h = entry.img:getDimensions()
    local frame_w, frame_h = img_w / obj.cols, img_h / obj.rows

    entry.frames = {}
    for y = 0, obj.rows do
      for x = 0, obj.cols do
        local q = love.graphics.newQuad( x * frame_w, y * frame_h, frame_w, frame_h, img_w, img_h )
        table.insert(entry.frames, q)
      end
    end

    img_atlas[obj.category][key] = entry
  end
end

function love.load()
  local files = love.filesystem.getDirectoryItems('assets/')
  local image_names = getFileNames(files)
  local data = LoadJSON('sprite_info.json')
  BuildAtlas(data)
end

function love.draw()
  local cat = img_atlas['character']['cat']
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(cat.img, cat.frames[1], 100, 100, 0, 2, 2, 1, 7)
end

function love.update()
end
