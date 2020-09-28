os.loadAPI("api/service.lua")

args = { ... }
msg = ... or "empty"
protocol = service.Service.protocol
id = 11

print("Sending message using protocol: "..protocol)
print(msg)

cmd = service.Command(service.Service.commandTypes.message, {message=msg})
rednet.open(service.getModemSide())
rednet.send(id, cmd, protocol)