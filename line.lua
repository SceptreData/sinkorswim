local ffi = require('ffi')

Line = {}
Line.__index = Line

local iterate_line = function (x0, y0, x1, y1)
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

for px, py in Line(0, 0, 10, 10) do
    print(px, py)
end
