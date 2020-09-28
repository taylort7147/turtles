assert(os.loadAPI("api/service"), "Required API missing: service")
local svc = service
local USAGE = "command COMMAND [ID]"


rednet.open(svc.getModemSide())


local commandName, id = ...
id = tonumber(id)

assert(type(commandName) == "string", USAGE)

command = svc.Command(commandName)
print("Sending command: "..commandName)

if not id then
  ids = {rednet.lookup(svc.SERVICE_PROTOCOL)}
  if table.maxn(ids) == 0 then
    error("No host found")
  end

  for _, id in pairs(ids) do
    print(id)
    rednet.send(id, command, svc.SERVICE_PROTOCOL)
  end
  
else
  assert(type(id) == "number", USAGE)
  rednet.send(id, command, svc.SERVICE_PROTOCOL)
end


