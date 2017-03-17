local lg = love.graphics
local lw = love.window

local Viewport = require('viewport')


Window = {}
Window.__index = Window

Window.desktop_w, Window.desktop_h = 0, 0

function Window:init()
  self.desktop_w, self.desktop_h = lw.getDesktopDimensions()
  self.viewport = Viewport(0, 0, lg.getWidth(), lg.getHeight())
end

return Window
