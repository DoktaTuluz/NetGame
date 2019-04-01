-- TODO: Fix connection glitch
local __socket__mod__ = require("socket")

udpSocket = __socket__mod__.udp()
udpSocket:settimeout(0)
udpSocket:setsockname("*", 50714)

local Clients = require("Clients")

local data, ip, port


    -- Interpret a given message in a table with pattern:
        -- [cmd]:msg|uuid;
local function interpret(messg, ip, port)
    local message = {
        cmd = messg:sub(messg:find("%[") + 1, messg:find("]") - 1),
        msg = messg:sub(messg:find(":") + 1, messg:find("|") - 1),
        uuid = messg:sub(messg:find("|") + 1, messg:find(";") - 1),
        from = {
            ip = ip,
            port = port
        }
    }

    return message
end


    -- Test the cmd of a message: "[cmd]:msg|uuid;"
local function act(message)
    if message["cmd"] == "CONNECTION" then  -- Add a new client
        if Clients.add(Clients.Client(message.uuid, message.from.ip, message.from.port)) then
            udpSocket:sendto("Connection accepted", message.from.ip, message.from.port)
        end
    elseif message["cmd"] == "DISCONNECTION" then   -- Remove a connected client
        if Clients.pop(message.uuid) == false then
            Clients.removeWaiter(message.uuid)
        end
    end
end


-- MAIN LOOP
local running = true
while running do
    data, ip, port = udpSocket:receivefrom()

    if data then
        local msg = interpret(data, ip, port)
        print(string.format("%d | %s on %s | %s >> [%s] %s", __socket__mod__.gettime(), ip, port, msg.uuid, msg.cmd, msg.msg))

        act(msg)
    end

    __socket__mod__.sleep(0.001)
end