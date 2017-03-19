local Tile = {}
Tile.__index = tile

local function new(id, data)
  local t = {
    id = id
    char = data.char or nil
    sprite = data.sprite and b

function Tile.mapChars()
  local c_map = {}
  for id, data in pairs(Atlas.tile) do
    local c = data.char
    c_map[c] = id
  end

  return c_map
end

function Tile.

function Tile.lookupChar(c)
  return Atlas.tile._map[c]
end

local UNIQUE_SET_MODE = {
  corners = {
function Tile.newUniqueSet(

return Tile
