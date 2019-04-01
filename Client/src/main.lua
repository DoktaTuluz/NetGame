local db = require("mydebug")

io.stdout:setvbuf("no")

function love.quit()
    return true
end

db.Print("+---------------------------------------------------------------+")
db.Print("|            NetGame - Walbach (c) Noé Toulouze 2019            |")
db.Print("+---------------------------------------------------------------+\n")

local mainGame = require("Game")


function love.load()
    -- Window setup
    love.window.setTitle("NetGame")
    love.window.setMode(800, 600, { fullscreen=false })

    mainGame:init()
end


function love.update(dt)
    mainGame:update(dt)
end


function love.draw()
    mainGame:draw()
end


function love.keypressed(key)
    mainGame:keypressed(key)
end