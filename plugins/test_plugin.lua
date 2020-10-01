local Plugin = require("plugins/plugin")
local EventManager = require("event_manager")

local TestPlugin = Plugin:new()
TestPlugin.abortKey = "q"

function TestPlugin:new(name)
  o = {
    name = name
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function TestPlugin:register(eventManager)
  eventManager:subscribe(EventManager.events.starting, function() self:onStarting() end)
  eventManager:subscribe(EventManager.events.stopping, function() self:onStopping() end)
  eventManager:subscribe("key", function(event, keyCode, isHeld) self:onKey(event, keyCode, isHeld) end)
end

function TestPlugin:say(message)
  print(self.name..":", message)
end

function TestPlugin:onKey(event, keyCode, isHeld)
  key = keys.getName(keyCode)
  self:say("onKey(key:"..key..", isHeld:"..tostring(isHeld)..")")
  if key == TestPlugin.abortKey then
    os.queueEvent(EventManager.events.abort)
  end
end

function TestPlugin:onStarting()
  self:say("Starting...")
  self:say("Press "..self.abortKey.." to abort.")
end

function TestPlugin:onStopping()
  self:say("Stopping...")
end

return TestPlugin