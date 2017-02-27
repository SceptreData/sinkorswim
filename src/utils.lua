local lume = require('lib/lume')
local json = require('lib/json')

local utils = {}

local PI = math.pi

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

-- -90
function utils.degreeToRadian(d)
  return d * PI / 180
end

return utils
