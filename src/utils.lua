local lume = require('lib/lume')
local json = require('lib/json')

local utils = {}

-- Local References

-- Love2D
local fs = love.filesystem

-- Lua
local pairs = pairs
local type = type
local assert = assert

-- Math
local PI = math.pi


-- TABLE FUNCTIONS

-- NOTE: Uses NYI FFI function (pairs)
local TABLE_PRINT_MODES = {
    k  = function(t) for k, _ in pairs(t) do print(k) end end,
    v  = function(t) for _, v in pairs(t) do print(v) end end,
    kv = function(t) for k, v in pairs(t) do print(k, v) end end
}

function utils.tableSize (t)
  local c = 0
  for k, _ in pairs(t) do c = c + 1 end
  return c
end


function utils.printTable(t, mode)
  assert (type(t) == 'table')
  local tPrint = TABLE_PRINT_MODES[mode or 'kv']
  if tPrint ~= nil then
    tPrint(t)
  else
    error("Invalid print mode. Expected: 'kv', 'k', 'v'. Got: " .. mode)
  end
end


function utils.getKeys(t)
  local keys = {}
  for k, _ in pairs(t) do
    keys[#keys + 1] = k
  end
  return keys
end


-- Filesystem


function utils.getFileNames(files)
  local t = {}
  for _, file in ipairs(files) do
    local name = lume.split(file, '.')
    table.insert(t, name[1])
  end
  return t
end


function utils.loadJSON(path)
  local contents, _ = fs.read(path)
  return json.decode(contents)
end


function utils.pause(condtion)
  if not condition then
    local answer
    repeat
      io.write('resume? (y)')
      io.flush()
      answer = io.read()
    until answer == 'y'
  end
end


-- Math

function utils.degreeToRadian(d)
  return d * PI / 180
end


function utils.inRange(i, min, max)
  return not (i > max or i < min)
end

-- For creating iterators around a 2D point.
function utils.around()
  return coroutine.create( function(x0, y0, r)
      local x, y = x0 - r, y0 - r
      coroutine.yield(x, y)
      while x ~= x0 + r do 
        x = x + 1
        coroutine.yield(x, y)
      end

      while y ~= y0 + r do
        y = y + 1
        coroutine.yield(x, y)
      end

      while x ~= x0 - r do
        x = x - 1
        coroutine.yield(x, y)
      end
      
      while  y ~= y0 - r + 1 do
        y = y - 1
        coroutine.yield(x, y)
      end
    end)
end

return utils
