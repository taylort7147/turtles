-----------------------
--    Service API    --
-----------------------
assert(os.loadAPI("api/util"), "Required API missing: util")

-----------------
-- Constants
-----------------
SERVICE_PROTOCOL = "protocol:service"

----------------------
-- Static variables --
----------------------


----------------------
-- Static functions --
----------------------

-- Gets the first side that contains a
-- modem, or nil if none is found.
function getModemSide()
  for _, side in ipairs(rs.getSides()) do 
    local pType = peripheral.getType(side)
    if pType == "modem" then
      return side
    end
  end
end

function isRunning(side)
  side = side or getModemSide()
  return rednet.isOpen(side), side
end

function host(protocol, hostname)
  rednet.host(protocol,hostname)
end

function unhost(protocol, hostname)
  rednet.unhost(protocol, hostname)
end

function sendCommand(receiverId, command, protocol, side)
  assert(isRunning(side or getModemSide()),"No modem is open")
  rednet.send(receiverId, command, protocol)
end

function sendMessage(receiverId, message, protocol)
  messageCommand = Command(ServerCommands.message, {message=message})
  sendCommand(receiverId, messageCommand, protocol)
end

function handleMessageCommand(senderId, command, protocol)
  message = command["message"]
  if message then print(message) end
end

-- Broadcasts a message
function broadcast(message, protocol, side)
  assert(isRunning(side or getModemSide()))
  rednet.broadcast(message, protocol)
end



---------------------
-- Command classes --
---------------------
function Command(commandName, kwargs)
  kwargs = kwargs or {}
  local self = { name=commandName}
  for k, v in pairs(kwargs) do
    self[k] = v
  end
  return self
end

-------------------
-- Service class --
-------------------

ServerCommands = {
  nop = "nop",
  message = "message",
  stop = "stop"
}

Server = {}
function Server:new(obj)
  obj = obj or {}
  setmetatable(obj, self)
  self.__index = self
  
  self.commands = {
    nop = function(sender, cmd, protocol) end,
    message = handleMessageCommand,
    stop = function (sender, cmd, protocol) self:stop() end
  }
  
  return obj
end

-- Starts the service
function Server:start(side)
  side = side or getModemSide()
  if not isRunning(side) then
    rednet.open(side)
  end
  
  -- Main loop
  while isRunning(side) do
    local senderId, command, protocol = rednet.receive(1)
    if command then
      status, err = pcall(function() self:handleCommand(senderId, command, protocol) end)
      if err then
        print("Exception occurred while handling command:")
        print(err)
      end
    end
  end 
end
  
function Server:handleCommand(senderId, command, protocol)
  if protocol == "dns" then return end
  print("Service received command: " .. tostring(command["name"]))  
  for commandName, callback in pairs(self.commands) do
    if command["name"] == commandName then
      return callback(senderId, command, protocol)
    end
  end
end

function Server:register(commandName, callback)
  assert(type(callback) == "function")
  self:unregister(commandName)
  self.commands[commandName] = callback
end

function Server:unregister(commandName)
  util.removeByValue(self.commands, commandName)
end

function Server:getCommands()
  return util.copy(self.commands)
end

-- Stops the server
function Server:stop(side)
  side = side or getModemSide()
  print("Stopping service.")
  if isRunning(side) then
    rednet.close(side)
  end
end



