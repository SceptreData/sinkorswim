local lg = love.graphics
local lw = love.window


Window = {}
Window.__index = Window

Window.screen_w, Window.screen_h = 0, 0
Window.desktop_w, Window.desktop_h = 0, 0

function Window.init()
  Window.desktop_w, Window.desktop_h = lw.getDesktopDimensions()
  Window.screen_w, Window.screen_h = lg.getDimensions()
end

return Window
