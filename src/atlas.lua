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

-- FILEPATH STUFF
local GAME_PATH = 'game/'

local RESTRICTED_CHARS = {'_', '.'}

local Atlas   = {}
Atlas.__index = Atlas

local stats = {
  num_entries     = 0,
  loaded_assets   = 0,
  protected_files = 0
}

Atlas.actors = {}
Atlas.boat   = {}
Atlas.env    = {}
Atlas.fx     = {}
Atlas.objs   = {}
Atlas.props  = {}

function Atlas:initialize()
  assert(fs.exists(DATA_PATH), "FATAL: Data directory does not exist!")
  assert(fs.exists(DATA_PATH .. BOOT_FILE), "Boot file path does not exist!")
  
  local boot_data    = loadJSON(DATA_PATH .. BOOT_FILE)
  local load_on_boot = arrayToSet(boot_data)

  local files = fs.getDirectoryItems(DATA_PATH)

  for i = 1, #files do
    local file = files[i]
    if fileIsProtected(file, RESTRICTED_CHARS) then
      stats.protected_files = stats.protected_files + 1
    else
      local load_now = load_on_boot[file]
      Atlas:newEntry(file, load_now or false)
      stats.num_entries = stats.num_entries + 1
    end
  end

  self:loadTiles()
end


local LOAD_FUNC = {
   lua  = loadLua,
  json  = loadJSON
}

--TODO Remove builDefault function, rework data
function Atlas:newEntry(filename, load_now)
  local f_type = getFileType(filename)
  local loadFunc = LOAD_FUNC[f_type]
  local asset = loadFunc(DATA_PATH .. filename)

  local entry = {
    id        = asset.id,
    name      = asset.name or nil,
    details   = asset.details or nil,
    defaults  = asset.defaults or nil,
    img_path  = asset.img or nil,
    img_sheet = asset.sheet or nil,
    anim_data = asset.animations or nil,
    map_asset = asset.map,
    isLoaded  = false
  }
  self[asset.category][asset.id] = entry
  
  if load_now == true then
    Atlas:Load(entry)
  end
end

local function _loadAssetFile(filename)
  local path = ASSET_PATH .. filename
  assert(fs.exists(path), path)
  local loadFunc = LOAD_FUNC[getFileType(filename)]
  return loadFunc(path)
end

-- TODO: Rework Data files so this isnt as horrifying
function Atlas:Load(entry)
  if entry.isLoaded then return end

  if entry.img_path then
    entry.img = lg.newImage(ASSET_PATH .. entry.img_path)
    entry.img:setFilter('nearest', 'nearest')
  end

  if entry.img_sheet then
    local sw, sh = Sprite.getDimensions(entry.img, entry.img_sheet)
    if entry.anim_data then
      entry.anim = Animation.build(entry.img, entry.anim_data, sw, sh)
    else
      entry.frames = Sprite.newStatic(entry.img, entry.img_sheet, sw, sh)
    end
    entry.sw, entry.sh = sw, sh
  end

  if entry.map_asset then
    entry.map_data = _loadAssetFile(entry.map_asset)
  end
  entry.isLoaded = true
  stats.loaded_assets = stats.loaded_assets + 1
end

function Atlas:loadTiles()
  assert(fs.exists(TILE_FILE))
  local data = loadJSON(TILE_FILE)

  for id, tile_data in pairs(data) do
    self.tile[id] = Tile(
    stats.num_entries = stats.num_entries + 1
  end
  self.tile._map = Tile.mapChars()
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
