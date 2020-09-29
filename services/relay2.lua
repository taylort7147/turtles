local SIDES = {
  "left",
  "right",
  "top",
  "bottom",
  "front",
  "back"
}

local function findPeripheral(type)
  print("Searching for", type)
  for _, side in ipairs(SIDES) do
    p = peripheral.getType(side)
    if p == type then
      print(type, "found on", side)
      return side
    end
  end
  print(type, "not found")
end

local function areAnyRedstoneInputsHigh()
  for _, side in ipairs(SIDES) do
    if redstone.getInput(side) then
      return true
    end
  end  
  return false
end

local function processRedstoneEvents(cb)
  while true do
    local evt = os.pullEvent()
    if evt == "redstone" then
      cb()
    end
  end
end

local function processRednetEvents(cb)
  while true do
    local senderId, message, protocol = rednet.receive()
    cb(senderId, message, protocol)
  end
end


-- Relay event
-- name: "relay"
-- p1 = master (bool)


-- External services
local service = {}
service.events = {
  relay = "relay"
}
service.commands = { 
  relay = "relay" 
}
service.rednet = {
  protocols = {
    relay = "protocol:relay"
  }
}


local function doWork()
  local turtleSide = findPeripheral("turtle")
  if not turtleSide then
    print("No turtle found")
    return
  end

  print("Sending pulse to turtle at ", turtleSide)
  redstone.setOutput(turtleSide, true)
  os.sleep(0.5)
  redstone.setOutput(turtleSide, false)
end

function service.onServiceEnable()
  print("onServiceEnable()")
  local modemSide = findPeripheral("modem")
  assert(modemSide)
  rednet.open(modemSide, service.rednet.protocols.relay)
end

function service.onRedstone()
  print("onRedstone()")
  if areAnyRedstoneInputsHigh() then
    local master = true
    os.queueEvent(service.events.relay, master)
  end
end

function service.onRelay(event, master)
  print("onRelay(", master, ")")
  if master then
    -- Rebroadcast over rednet
    print("Broadcasting:", service.commands.relay, "using protocol:", service.rednet.protocols.relay)
    rednet.broadcast(service.commands.relay, service.rednet.protocols.relay)
  end

  doWork()
end

function service.onRednetMessage(event, senderId, message, protocol)
  print("onRednetMessage(", senderId, ", ", message, ", ", protocol, ")")
  if protocol == service.rednet.protocols.relay and message == service.commands.relay then
    local master = false
    os.queueEvent(service.events.relay, master)
  end
end




return service