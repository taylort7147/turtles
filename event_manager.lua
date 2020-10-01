local Set = require("set")


local EventManager = {}
EventManager.events = {
  starting = "starting",
  abort = "abort",
  stopping = "stopping"
}

function EventManager:new()
  local o = {
    subscriptionsByEvent = {}
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function EventManager:subscribe(event, cb)
  self.subscriptionsByEvent[event] = self.subscriptionsByEvent[event] or Set:new()
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

function EventManager:run(func)
  self:handleEvent(self.events.starting)

  while true do
    local event, p1, p2, p3, p4, p5 = os.pullEvent()
    if event == EventManager.events.abort then break end
    self:handleEvent(event, p1, p2, p3, p4, p5)
  end
  
  self:handleEvent(self.events.stopping)
end


return EventManager