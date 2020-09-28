-- Set to true to enable the service
-- or false to disable it.
local FILE_SERVICE_ENABLED = true

------------------
-- Dependencies --
------------------
assert(os.loadAPI("api/service.lua"), "Required API missing: service")
assert(not FILE_SERVICE_ENABLED or os.loadAPI("api/fileservice.lua"), "Register API missing: fileservice")
local svc = service
local fs = fileservice

-- Hostname is derived from own ID
local hostname = "Computer_"..tostring(os.getComputerID())


-- Create the server
s = svc.Server:new()

-- Host protocols
svc.host(svc.SERVICE_PROTOCOL, hostname)
if FILE_SERVICE_ENABLED then
  svc.host(fs.FILE_SERVICE_PROTOCOL, hostname)

  for command, callback in pairs(fs.FileServiceCommandCallbacks) do
    s:register(command, callback)
  end
  print("fileservice enabled")
end

print("Registered commands:")
local registeredCommands = s:getCommands()
for command, _ in pairs(registeredCommands) do
  print(command)
end

-- Start the server
s:start()



