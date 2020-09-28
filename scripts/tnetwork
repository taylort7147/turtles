-- Set to true to enable the service
-- or false to disable it.
local FILE_SERVICE_ENABLED = true
local TREE_FARM_SERVICE_ENABLED = false

-- Files (only used if corresponding
-- service is enabled)
local TREE_FARM_ROUTINE_FILENAME = "routines/tree_farm_routine"

------------------
-- Dependencies --
------------------
assert(os.loadAPI("api/service"), "Required API missing: service")
assert(not FILE_SERVICE_ENABLED or os.loadAPI("api/fileservice"), "Register API missing: fileservice")
assert(not TREE_FARM_SERVICE_ENABLED or os.loadAPI("api/treefarmservice"), "Register API missing: treefarmservice")
local svc = service
local fs = fileservice
local tfs = treefarmservice

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


if TREE_FARM_SERVICE_ENABLED then
  svc.host(tfs.TREE_FARM_SERVICE_PROTOCOL, hostname)
  
  s:register(tfs.TreeFarmServiceCommands.start,
    tfs.generateStartCommandCallback(TREE_FARM_ROUTINE_FILENAME))
  print("treefarmservice enabled")
end

print("Registered commands:")
local registeredCommands = s:getCommands()
for command, _ in pairs(registeredCommands) do
  print(command)
end

-- Start the server
s:start()



