local db = require("mydebug")

io.stdout:setvbuf("no")

db.Print("+-------------------------------------------------------------------+")
db.Print("|            NetGame - Wettolsheim (c) Noé Toulouze 2019            |")
db.Print("+-------------------------------------------------------------------+\n")

local sock = require("SocketConnection")
local mainGame = require("Game")


function love.load()
    -- Window setup
    love.window.setTitle("NetGame")
    love.window.setMode(800, 600, { fullscreen=false })

    -- Server setup
    sock:init("192.168.0.6", 50714)
    -- Try to connect to the server while not connected
    sock:send(0, "CONNECTION", "Connect to the server")

    mainGame:init()
end


function love.update(dt)
    sock:checkSocket()
    mainGame:update(dt)
end


function love.draw()
    if sock.connected == false then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.print("WAITING FOR AN AVAILABLE SERVER", 100, 100)
        love.graphics.setColor(1, 1, 1, 1)
        return
    end

    mainGame:draw()
end


    -- Exit the program
local function exitProgram()
    sock:send(0, "DISCONNECTION", "Disconnect from the server")
    os.exit()
end


function love.keypressed(key)
    if key == "escape" then
        exitProgram()
    end

    mainGame:keypressed(key)
end