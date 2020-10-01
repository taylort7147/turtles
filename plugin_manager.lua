EventManager = require("event_manager")

local PluginManager = {}

function PluginManager:new()
  local o = {
    eventManager = EventManager:new()
  }
  setmetatable(o, self)
  self.__index = self
  return o
end

function PluginManager:register(plugin)
  plugin:register(self.eventManager)
end

function PluginManager:unregister(plugin)
  plugin:unregister(self.eventManager)
end

function PluginManager:start()
  self.eventManager:run()
end


return PluginManager
