------------------
-- File Service --
------------------
os.loadAPI("api/service.lua")
local svc = service -- Shorthand

-------------------------------
-- Inherit fields in service --
-------------------------------
local Command = svc.Command


FILE_SERVICE_PROTOCOL = "protocol:file_service"
  

function FileTransferCommand(filename)
  local fh, err = io.open(filename, "r")
  local contents = ""
  local size = 0
  if fh then
    contents = fh:read("*a")
    fh:close()
    size = contents:len()
  end
  self = Command(FileServiceCommands.fileTransfer, {
    filename=filename,
    contents = contents,
    size = size,
    err = err or ""
  })
  return self
end

-- TODO: Security
function sendFile(receiverId, filename)
  print("Sending " .. filename .. " to " .. tostring(receiverId))
  command = FileTransferCommand(filename)
  svc.sendCommand(receiverId, command, FILE_SERVICE_PROTOCOL)
end

-- TODO: Security
function receiveFile(senderId, filename, size, contents, err)
  print("Receiving file: "..tostring(filename).." ("..tostring(size)..")")
  if size and size > 0 then
    fh, err = io.open(filename, "w")
    if not fh then
      print("Error writing file: "..tostring(err))
    else
      fh:write(contents)
      fh:close()
    end
  else
    print("Empty file.")
  end
end

-- TODO: Security
function handleFileRequestCommand(senderId, command, protocol) 
  -- print("Computer with ID " .. tostring(senderId) .. " requested a file using protocol: " .. protocol)
  filename = command["filename"]
  assert(filename, "No filename specified.")
  sendFile(senderId, filename, protocol) 
end

-- TODO: Security
function handleFileTransferCommand(senderId, command, protocol)
  assert(command)
  local filename = command.filename
  local size = command.size
  local contents = command.contents
  local err = command.err
  receiveFile(senderId, filename, size, contents, err)
end

-- TODO: Security
function handleUpdateAllCommand(senderId, command, protocol)
  fh = io.open("data/update_list", "r")
  if not fh then
    print("Missing data/update_list")
    svc.sendMessage(senderId, "Missing update_list")
    return
  end
  
  print("Updating "..tostring(senderId))
  for filename in fh:lines() do
    if type(filename) == "string" and fs.exists(filename) then
      sendFile(senderId, filename, protocol)
    end
  end
  fh:close()
  svc.sendMessage(senderId, "Success")
end



FileServiceCommands = {
  fileRequest = "file_request",
  fileTransfer = "file_transfer",
  updateAll = "update_all"
}

FileServiceCommandCallbacks = {
  file_request = handleFileRequestCommand,
  file_transfer = handleFileTransferCommand,
  update_all = handleUpdateAllCommand
}



