local Tile = {}
Tile.__index = tile

function Tile.mapChars()
  local c_map = {}
  for id, data in pairs(Atlas.tile) do
    local c = data.char
    c_map[c] = id
  end

  return c_map
end

return Tile
