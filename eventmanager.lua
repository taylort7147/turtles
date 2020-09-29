local SIDES = {
  "left",
  "right",
  "top",
  "bottom",
  "front",
  "back"
}

-- TODO: Move to file
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


-- Set class
local Set = {}
Set.__index = Set

function Set.new()
  local self = {}
  return setmetatable(self, Set)
end

function Set:insert(subscription)
  self[subscription] = true
  return self
end

function Set:remove(subscription)
  self[subscription] = nil
  return self
end

function Set:contains(subscription)
  return self[subscription] ~= nil
end

function Set:size()
  return #self
end


-- EventManager class
local EventManager = {}
EventManager.__index = EventManager
EventManager.events = {
  serviceEnable = "service_enable"
}

function EventManager.new()
  local self = {
      subscriptionsByEvent = {}
  }
  return setmetatable(self, EventManager)
end

function EventManager:subscribe(event, cb)
  self.subscriptionsByEvent[event] = self.subscriptionsByEvent[event] or Set.new()
  local subscriptions = self.subscriptionsByEvent[event]
  subscriptions:insert(cb)
end

function EventManager:unsubscribe(event, cb)
  subscriptions = self.subscriptionsByEvent[event]
  if subscriptions then
    subscriptions:remove(cb)
  end
end

function EventManager:handleEvent(event, p1, p2, p3, p4, p5)
  local subscriptions = self.subscriptionsByEvent[event]
  if subscriptions then
    for cb, _ in pairs(subscriptions) do
      cb(event, p1, p2, p3, p4, p5)
    end
  end
end

function EventManager:start(func)
  self:handleEvent(self.events.serviceEnable)

  while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()
    print("Event: ", event)
    self:handleEvent(event, p1, p2, p3, p4, p5)
  end

end


return EventManager