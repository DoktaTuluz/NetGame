local db = require("mydebug")
local __socket__mod__ = require("socket")


local function genUUID()
    math.randomseed(os.time())
    local template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"
    return string.gsub(template, '[xy]',
        function (c)
            return string.format('%x', (c == 'x') and love.math.random(0, 0xf) or love.math.random(8, 0xb))
        end )
end


local SockConnection = {}
SockConnection.UUID = ""
SockConnection.sock = nil -- The socket
SockConnection.connected = false

SockConnection.CONNECTION_MAX_TIMER = 5
SockConnection.connectionTimer = 0

    -- List containing all the IP addresses of the servers
SockConnection.listAvailableServers = {
    "192.168.0.6",
    "192.168.0.14"
}
SockConnection.CONNECTION_PORT = 50714
SockConnection.server = 1


    -- Prefer SockConnection:getPeerServer() rather than SockConnection.listAvailableServers[math.floor(self.server)]
function SockConnection:getPeerServer()
    return self.listAvailableServers[math.floor(self.server)]
end


function SockConnection:init()
    self.UUID = genUUID()

    self.sock = __socket__mod__.udp()
    self.sock:settimeout(0)
    self.sock:setpeername(self:getPeerServer(), self.CONNECTION_PORT)
    self:tryToConnect()
end


function SockConnection:tryToConnect()
    self:send(0, "CONNECTION", "Connect to the server "..self:getPeerServer())
    db.Print("Trying to get an access to the server "..self:getPeerServer())
end


    -- type: int - message (0), warning (1), error (2), critical (3)
    -- cmd: string - the command we send to the server
    -- msg: string - parameters or error message
function SockConnection:send(type, cmd, msg)
    local datag = "["..cmd.."]:"..msg.."|"..self.UUID..";"
    self.sock:send(datag)
end


    -- Check if we receive something
function SockConnection:checkSocket(dt)
    local data, msg = self.sock:receive()

    if data then
        db.Print("Received at "..tostring(__socket__mod__.gettime())..": ", data)
        if data == "Connection accepted" then
            self.connected = true
        end
        return data
    elseif msg ~= "timeout" then
        db.Print("Network error: "..tostring(msg))
        return "Disconnection"
    end

    return ""
end


function SockConnection:sleep(time)
    __socket__mod__.sleep(time)
end


function SockConnection:update(dt)
    if self.connected == false then
        self.connectionTimer = self.connectionTimer + dt

        if self.connectionTimer >= self.CONNECTION_MAX_TIMER then
            self.connectionTimer = 0
            self:send(0, "DISCONNECTION", "Cut off the bound with the server "..self:getPeerServer())
            db.Print("Response time too long with the server "..self:getPeerServer()..". Disconnecting")
            self.server = self.server + 1
            if self.server > #self.listAvailableServers then
                self.server = 1
            end
            self.sock:setpeername(self:getPeerServer(), self.CONNECTION_PORT)
            self:tryToConnect()
        end
    end
end

return SockConnection