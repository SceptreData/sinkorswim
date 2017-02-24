

local img_atlas = { character = {}, fx = {} }


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
  --local files = love.filesystem.getDirectoryItems('../assets/')
  print(love.filesystem.getSource())
  local files = love.filesystem.getDirectoryItems('../data')
  for k, file in ipairs(files) do
    print(k .. ". " .. file) --outputs something like "1. main.lua"
  end
  print(love.filesystem.exists(path))
  local data = utils.loadJSON('../data/sprite_info.json')
  BuildAtlas(data)
end

function love.draw()
  local cat = img_atlas['character']['cat']
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(cat.img, cat.frames[1], 100, 100, 0, 2, 2, 1, 7)
end

function love.update()
end
