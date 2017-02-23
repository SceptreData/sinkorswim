ConfigTable = {}

function love.conf(t)
  t.identity = "sinkorswim"
  t.window.title = "Sink or Swim"

  t.window.width = 1200
  t.window.height = 720

  t.window.fsaa = 4
  t.window.vsync = true
  
  t.modules.joysticks = false
  t.modules.physics = false
  t.modules.touch = false
end
