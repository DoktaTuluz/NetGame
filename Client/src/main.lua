local db = require("mydebug")

io.stdout:setvbuf("no")

function love.quit()
    return true
end

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
    sock:init()

    mainGame:init()
end


function love.update(dt)
    for e in love.event.poll() do
        if e == "quit" then
            exitProgram()
        end
    end

    sock:checkSocket()
    sock:update(dt)
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