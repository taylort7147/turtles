os.loadAPI("api/service")
os.loadAPI("api/fileservice")
os.loadAPI("env")
local svc = service
local fsvc = fileservice

rednet.open(svc.getModemSide())
id = rednet.lookup(fsvc.FILE_SERVICE_PROTOCOL, env.mainServer)
if id == nil then
  print("Host not found")
  exit(-1)
end


local commandName = fsvc.FileServiceCommands.fileRequest
for _, filename in ipairs({ ... }) do
  local command = svc.Command(commandName, {filename=filename})
  rednet.send(id, command, fsvc.FILE_SERVICE_PROTOCOL)
  -- responseId, response, protocol = rednet.receive(fsvc.FileService.protocol, 1)
  -- if not response then
    -- print("No response")
    -- break
  -- end
  
  -- receivedCommand = response
  -- if not receivedCommand then
    -- print("Command is nil")
    -- break
  -- end
  
  -- if receivedCommand["type"] == fsvc.FileService.commandNames.fileTransfer then
    -- print(tostring(receivedCommand.filename).." ("..tostring(receivedCommand.size)..")")
    -- fh = io.open(receivedCommand.filename, "w")
    -- fh:write(receivedCommand.contents)
    -- fh:close()
  -- end
end