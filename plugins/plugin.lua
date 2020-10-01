Plugin = {}

function Plugin:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Plugin:register(eventManager)
end

return Plugin