local Clients = {}

Clients.MAX = 4
Clients.list = {}
Clients.waitList = {}


function Clients.addWaiter(client)
    if client == nil then return end

    table.insert(Clients.waitList, client)
    print(client.UUID.." put in the waiting list")
end


function Clients.moveWaiterToActive(name)
    for i, c in ipairs(Clients.waitList) do
        if c.UUID == name then
            Clients.add(c)
            break
        end
    end

    Clients.removeWaiter(name)
end


function Clients.removeWaiter(name)
    for i, c in ipairs(Clients.waitList) do
        if c.UUID == name then
            table.remove(Clients.waitList, i)
            return
        end
    end
end


function Clients.add(client)
    print(client.UUID.." is trying to connect...")
    if #Clients.list == Clients.MAX then
        print("Can't add any client anymore.")
        Clients.addWaiter(client)
        return false
    end

    for i, c in ipairs(Clients.list) do
        if c.UUID == client.UUID then
            print("Can't add twice the same client.")
            return false
        end
    end

    table.insert(Clients.list, client)
    print("Connect > "..client.UUID)
    return true
end


function Clients.pop(name)
    print(name.." is trying to disconnect itself...")

    for i, c in ipairs(Clients.list) do
        if c.UUID == name then
            table.remove(Clients.list, i)
            print("Disconnecting > "..c.UUID)
            if #Clients.waitList > 0 then   -- Accept a waiting client if there is one
                udpSocket:sendto("Connection accepted", Clients.waitList[1].ip, Clients.waitList[1].port)
                print("> Allowing "..Clients.waitList[1].UUID.." to create a bound at "..require("socket").gettime())
            end
            return
        end
    end

    print(name.." wasn't connected")
end


    -- Client class
function Clients.Client(uuid, ip, port)
    local client = {
        UUID = uuid,
        ip = ip,
        port = port
    }

    return client
end

return Clients