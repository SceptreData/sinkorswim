local Tile = {}
Tile.__index = tile

function Tile.mapChars(group)
  local c_map = {}
  for id, data in pairs(Atlas[group].tile) do
    local c = data.char
    c_map[c] = id
  end
  return c_map
end

function Tile.lookup(group, c)
  return Atlas[group].tile._map[c]
end

function Tile.getGroup(group)
  assert(type(group) == 'string')
  return Atlas[group].tile
end

function Tile.getTileFrom(group, c)
  local tile_entry = Tile.lookup(group, c)
  return Atlas[group].tile[tile_entry]
end

return Tile
