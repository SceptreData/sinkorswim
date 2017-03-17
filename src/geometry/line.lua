Line = {}
Line.__index = Line

local round = function(...)
  local arg = {...}
  if #arg == 1 then
    local n = arg[1]
    return n>= 0 and math.floor(n + .5) or math.ceil(n - .5)
  else
    local t = {}
    for i, v in ipairs(arg) do
      table.insert(t, round(v))
    end
    return unpack(t)
  end
end

local iterate_line = function (x0, y0, x1, y1)
   x0, y0, x1, y1 = round(x0, y0, x1, y1)
   local dx, dy = math.abs(x1 - x0), -math.abs(y1 - y0)
   local sx, sy = x0 < x1 and 1 or -1, y0 < y1 and 1 or -1
   local err, e2 = dx + dy

   while (x0 ~= x1 and y0 ~= y1) do
       e2 = 2 * err
       if e2 >= dy then
           err = err + dy
           x0 = x0 + sx
       end
       if e2 <= dx then
           err = err + dx
           y0 = y0 + sy
       end
       coroutine.yield(x0, y0)
   end
end

function Line.midpoint (x0, y0, x1, y1)
    return (x0 + x1) / 2, (y0 + y1) / 2
end

function Line.getPoints (x0, y0, x1, y1)
    local co = coroutine.create(function () iterate_line(x0, y0, x1, y1) end)
    return function ()
        if coroutine.status(co) == 'dead' then
            co = coroutine.create(function() iterate_line(x0, y0, x1, y1) end)
        end
        local code, nextx, nexty = coroutine.resume(co)
        if not code then return nil end
        return nextx, nexty
    end
end

setmetatable(Line, {__call = function(self, x0, y0, x1, y1)
                                return  Line.getPoints(x0, y0, x1, y1)
end})

return Line
