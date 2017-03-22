local lume      = require('lib/lume')
local Log       = require('lib/log')

local Animation = require('component.animation')
local Sprite    = require('sprite')
local Tile      = require('tile')
local utils     = require('utils')

-- Iternalization
local arrayToSet  = utils.arrToSet
local loadJSON    = utils.loadJSON
local loadLua     = utils.loadLua
local getFileType = utils.getFileType
local fileIsProtected = utils.fileIsProtected

local lg = love.graphics
local fs = love.filesystem

-- ATLAS OPTIONS
local GAME_PATH = 'game/'
local RESTRICTED_CHARS = {'_', '.'}
local LOAD_ALL = true

local CHAPTERS = {'actor', 'boat', 'env', 'fx', 'obj', 'prop'}

local Atlas   = {}
Atlas.__index = Atlas

local stats = {
  num_entries     = 0,
  loaded_assets   = 0,
}

local LOAD_FUNC = {
   lua  = loadLua,
  json  = loadJSON
}


local function isAsset(path, file)
  return (fs.isFile(path .. file) and not fileIsProtected(file, RESTRICTED_CHARS))
end


local function loadAsset(path)
  assert(fs.exists(path))
  local loadFunc = LOAD_FUNC[getFileType(path)]
  return loadFunc(path)
end

-- TODO: MAYBE rework this to just unpack the json object.
--       Have fields potentially be multiple types, for instance if
--       img == type(String) then we know img hasnt been loaded
local function newEntry(asset)
  local entry = {
    id        = asset.id,
    name      = asset.name or nil,
    char      = asset.char or nil,
    static    = asset.static or nil,
    info      = asset.details or asset.attributes or nil,
    defaults  = asset.defaults or nil,
    img_file  = asset.img or nil,
    spr_sheet = asset.sprite_sheet or nil,
    anim_data = asset.animations or nil,
    map_asset = asset.map or nil,
    isLoaded  = false
  }
  return entry
end


function Atlas:initialize()
  assert(fs.exists(GAME_PATH), "FATAL: Data directory does not exist!")
  for _, chapter in ipairs(CHAPTERS) do
    if not Atlas[chapter] then Atlas[chapter] = {} end
    local path = GAME_PATH .. chapter.. '/'
    local files = fs.getDirectoryItems(path)
    for i = 1, #files do
      local file = files[i]
      if isAsset(path, file) then 
        local asset = loadAsset(path .. file)
        if asset.array then 
          self:addGroup(chapter, asset.id, asset.array)
        else
          self:addTo(chapter, newEntry(asset))
        end
      end
    end
  end
  self.boat.tile._map = Tile.mapChars("boat")
end


function Atlas:get(val_str)
  local sections = lume.split(val_str, '.')
  local target, root = self, GAME_PATH .. sections[1] .. '/'
  for i = 1, #sections do
    target = target[sections[i]]
  end
  return target, GAME_PATH.. sections[1] .. '/'
end

function Atlas:addTo(atl_path, entry, load_now)
  local t = self:get(atl_path)
  assert(t, "trying to add to invalid atlas path: ".. atl_path)
  t[entry.id] = entry

  stats.num_entries = stats.num_entries + 1
  if LOAD_ALL == true or load_now == true then
    self:Load(atl_path .. '.' .. entry.id)
  end
end
  
function Atlas:addGroup(chapter, id, assets)
  if not self[chapter][id] then self[chapter][id] = {} end
  local atl_path = chapter ..'.'.. id
  for i = 1, #assets do
    local entry = newEntry(assets[i])
    self:addTo(atl_path, entry) 
  end
end

-- TODO: Rework Data files so this isnt as horrifying
function Atlas:Load(atl_path)
  local entry, root = self:get(atl_path)
  assert(entry)
  if entry.isLoaded then return end

  if entry.img_file then
    entry.img = lg.newImage(root .. 'images/'.. entry.img_file)
    entry.img:setFilter('nearest', 'nearest')
  end

  if entry.spr_sheet then
    local sw, sh = Sprite.getDimensions(entry.img, entry.spr_sheet)
    if entry.anim_data then
      entry.anim = Animation.build(entry.img, entry.anim_data, sw, sh)
    else
      entry.sprites = Sprite.newStatic(entry.img, entry.spr_sheet, sw, sh)
    end
    entry.sw, entry.sh = sw, sh
  end

  if entry.map_asset then
    entry.map_data = loadAsset(root .. 'models/' .. entry.map_asset.model)
  end
  entry.isLoaded = true
  stats.loaded_assets = stats.loaded_assets + 1
end

function Atlas:unload(entry)
  if not entry.isLoaded then return end
  entry.img      = nil
  entry.anim     = nil
  entry.frames   = nil
  entry.map_data = nil
  entry.sw, entry.sh = nil, nil
  
  entry.isLoaded = false
  stats.loaded_assets = stats.loaded_assets - 1
end

function Atlas:getStats()
  return stats
end

return Atlas
