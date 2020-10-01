-- Set class
local Set = {}

function Set:new(t)
  local o = t or {}
  setmetatable(o, self)
  self.__index = self
  return o
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

return Set