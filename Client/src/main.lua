local db = require("mydebug")

io.stdout:setvbuf("no")

db.Print("+--------------------------------------------------------------+")
db.Print("|            NetGame - Colmar (c) Noé Toulouze 2019            |")
db.Print("+--------------------------------------------------------------+\n")

local sock = require("SocketConnection")
local mainGame = require("Game")


function love.load()
    -- Window setup
    love.window.setTitle("NetGame")
    love.window.setMode(800, 600, { fullscreen=false })

    -- Server set up
    sock:init("192.168.0.6", 50714)
    sock:send(0, "CONNECTION", "")

    mainGame:init()
end


function love.update(dt)
    mainGame:update(dt)
end


function love.draw()
    mainGame:draw()
end


    -- Exit the program
local function exitProgram()
    sock:send(0, "DECONNECTION", "Cut the bound with the server")
    os.exit()
end


function love.keypressed(key)
    if key == "escape" then
        exitProgram()
    end

    mainGame:keypressed(key)
end