os.loadAPI("api/service.lua")
os.loadAPI("api/fileservice.lua")
os.loadAPI("env.lua")
local svc = service
local fsvc = fileservice

rednet.open(svc.getModemSide())
local cmd = svc.Command(fsvc.FileServiceCommands.updateAll)
local protocol = fsvc.FILE_SERVICE_PROTOCOL
local timeout = 5
local id = rednet.lookup(protocol, env.mainServer)

if not id then
  print("Host not found")
  exit(-1)
end

rednet.send(id, cmd, protocol)